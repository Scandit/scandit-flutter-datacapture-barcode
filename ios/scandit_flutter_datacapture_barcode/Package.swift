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
    .package(path: "../../scandit-flutter-datacapture-core/ios/scandit_flutter_datacapture_core")
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
