// swift-tools-version: 5.9
import Foundation
import PackageDescription

// Locate a sibling frameworks/shared/ios/<target> on disk by walking up from
// the package directory. If found, we're in a checkout that ships the
// shared frameworks alongside (dev repo, in-tree integration test, or any
// future layout that does the same) and the caller uses the local source.
// If not found, the caller falls back to the GitHub URL dependency.
func findLocalFrameworksPath(target: String) -> String? {
    let fm = FileManager.default
    var dir = Context.packageDirectory as NSString
    while true {
        let candidate = dir.appendingPathComponent("frameworks/shared/ios/\(target)")
        if fm.fileExists(atPath: candidate) {
            return candidate
        }
        let parent = dir.deletingLastPathComponent
        if parent == dir as String { return nil }
        dir = parent as NSString
    }
}

// Resolve a sibling scandit_flutter_datacapture_* SwiftPM package. Its directory
// name varies by consumer setup: Flutter's generated aggregate symlinks it under
// .packages named "<pkg>", "<pkg>-<version>", or a hyphenated path-dependency
// basename (which of these depends on the Flutter version); a pub-cache or git
// checkout stamps it with a version or commit hash; the in-repo dev tree uses the
// plain source path. The sibling is therefore located at manifest-evaluation time.
//
// Primary strategy: probe the known layouts directly with String(contentsOfFile:).
// The version segment uses this plugin's own version, which matches the sibling's
// because the plugins are released in lockstep — picking the right one when several
// versions are cached side by side. String reads work under the SwiftPM manifest
// sandbox (Xcode 16+), so the common case never depends on FileManager.
//
// Fallback strategy: a git dependency's directory carries a commit hash whose value
// isn't known here, so if the known layouts miss, enumerate nearby directories and
// match by name (tolerating a "-<version>"/"-<hash>" suffix).
//
// A matched directory is returned as-is (symlinks unresolved, no ".." segment) so
// its name matches the reference in Flutter's generated aggregate — letting SwiftPM
// de-duplicate the two rather than report a conflict — and so this probe and
// SwiftPM agree on the location (SwiftPM normalizes ".." lexically, the filesystem
// resolves it through symlinks).
func findPluginPackagePath(_ packageName: String, version: String) -> String {
    let hyphenated = packageName.replacingOccurrences(of: "_", with: "-")

    // A SwiftPM package directory either holds Package.swift directly (Flutter
    // symlinks the package dir) or nests it under ios/<packageName> (pub-cache and
    // dev tree). Existence is checked with String(contentsOfFile:), never
    // FileManager, so it works under the manifest sandbox.
    func manifestDirectory(_ path: String) -> String? {
        if (try? String(contentsOfFile: path + "/Package.swift", encoding: .utf8)) != nil {
            return path
        }
        let inner = (path as NSString).appendingPathComponent("ios/\(packageName)")
        if (try? String(contentsOfFile: inner + "/Package.swift", encoding: .utf8)) != nil {
            return inner
        }
        return nil
    }

    let base = Context.packageDirectory as NSString
    let oneUp = base.deletingLastPathComponent
    let threeUp =
        ((base.deletingLastPathComponent as NSString).deletingLastPathComponent as NSString)
        .deletingLastPathComponent
    let knownCandidates = [
        "\(oneUp)/\(packageName)-\(version)",  // Flutter aggregate symlink, versioned basename (hosted)
        "\(oneUp)/\(packageName)",  // Flutter aggregate symlink, unversioned name (hosted)
        "\(oneUp)/\(hyphenated)",  // Flutter aggregate symlink, local path dependency
        "\(threeUp)/\(packageName)-\(version)/ios/\(packageName)",  // pub-cache / no-symlink layout (real path)
        "\(threeUp)/\(hyphenated)/ios/\(packageName)",  // in-repo dev tree
    ]
    for candidate in knownCandidates
    where (try? String(contentsOfFile: candidate + "/Package.swift", encoding: .utf8)) != nil {
        return candidate
    }

    // Match "<pkg>" exactly, or "<pkg>-<suffix>" where the suffix is a version
    // (dotted, e.g. 8.5.1 or 8.5.0-beta.1) or a commit hash (7+ hex chars) — the
    // two forms pub uses for cached dependencies. Requiring that shape keeps a
    // longer sibling such as "...-id-aamva-barcode-verification" from matching a
    // shorter name, and the "-" separator keeps "<pkg>_count" from matching "<pkg>".
    func matchesPackage(_ entry: String) -> Bool {
        for candidateBase in [packageName, hyphenated] {
            if entry == candidateBase {
                return true
            }
            if entry.hasPrefix(candidateBase + "-") {
                let suffix = entry.dropFirst(candidateBase.count + 1)
                if let first = suffix.first, first.isNumber, suffix.contains(".") {
                    return true
                }
                if suffix.count >= 7, suffix.allSatisfy({ $0.isHexDigit }) {
                    return true
                }
            }
        }
        return false
    }

    let fileManager = FileManager.default
    var directory = base
    while true {
        let parent = directory.deletingLastPathComponent
        if let entries = try? fileManager.contentsOfDirectory(atPath: parent) {
            for entry in entries where matchesPackage(entry) {
                if let found = manifestDirectory((parent as NSString).appendingPathComponent(entry)) {
                    return found
                }
            }
        }
        if parent == directory as String {
            break
        }
        directory = parent as NSString
    }

    let attempted = knownCandidates.joined(separator: "\n  - ")
    fatalError(
        "Could not locate the \(packageName) SwiftPM package relative to \(base). "
            + "Probed:\n  - \(attempted)\nand a scan of the parent directories "
            + "found no match — the Flutter SwiftPM layout may have changed or a "
            + "plugin version is mismatched."
    )
}

// Read version from pubspec.yaml
func getVersion() -> String {
    let pubspecPath = Context.packageDirectory + "/../../pubspec.yaml"
    guard let content = try? String(contentsOfFile: pubspecPath, encoding: .utf8) else {
        fatalError("Could not read pubspec.yaml at \(pubspecPath)")
    }

    // Parse version line (format: "version: X.Y.Z")
    let lines = content.components(separatedBy: .newlines)
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("#") {
            continue
        }
        if trimmed.hasPrefix("version:") {
            let versionString =
                trimmed
                .replacingOccurrences(of: "version:", with: "")
                .trimmingCharacters(in: .whitespaces)
            return versionString
        }
    }

    fatalError("Could not find version in pubspec.yaml at \(pubspecPath)")
}

let version = getVersion()

// Configure dependencies based on environment
// Automatically use local path if it exists, otherwise use published package
var dependencies: [Package.Dependency] = [
    .package(
        name: "scandit_flutter_datacapture_core",
        path: findPluginPackagePath("scandit_flutter_datacapture_core", version: version)
    )
]

if let localPath = findLocalFrameworksPath(target: "scandit-datacapture-frameworks-barcode") {
    dependencies.append(.package(path: localPath))
} else {
    dependencies.append(
        .package(
            url: "https://github.com/Scandit/scandit-datacapture-frameworks-barcode.git",
            exact: Version(stringLiteral: version)
        )
    )
}

let package = Package(
    name: "scandit_flutter_datacapture_barcode",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "scandit-flutter-datacapture-barcode",
            targets: ["scandit_flutter_datacapture_barcode"]
        )
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "scandit_flutter_datacapture_barcode",
            dependencies: [
                .product(name: "scandit-flutter-datacapture-core", package: "scandit_flutter_datacapture_core"),
                .product(name: "ScanditFrameworksBarcode", package: "scandit-datacapture-frameworks-barcode"),
            ],
            path: "Sources/scandit_flutter_datacapture_barcode"
        )
    ]
)
