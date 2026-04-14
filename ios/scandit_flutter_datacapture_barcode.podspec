# TODO: https://jira.scandit.com/browse/SDC-5384

require "yaml"
require "json"

pubspec = YAML.load_file(File.join("..", "pubspec.yaml"))

version = pubspec["version"]

spm_enabled = lambda {
  current_path = File.expand_path(__dir__)
  12.times do
    plugins_file = File.join(current_path, ".flutter-plugins-dependencies")
    if File.exist?(plugins_file)
      begin
        dependencies_hash = JSON.parse(File.read(plugins_file))
        return dependencies_hash.dig("swift_package_manager_enabled", "ios") == true
      rescue JSON::ParserError
        return false
      end
    end

    parent = File.dirname(current_path)
    break if parent == current_path
    current_path = parent
  end

  false
}.call

Pod::Spec.new do |s|
  s.name                    = pubspec["name"]
  s.version                 = version
  s.summary                 = pubspec["description"]
  s.homepage                = pubspec["homepage"]
  s.license                 = { :file => "../LICENSE" }
  s.author                  = { "Scandit" => "support@scandit.com" }
  s.platforms               = { :ios => "15.0" }
  s.source                  = { :path => "." }
  s.swift_version           = "5.0"
  s.source_files            = "scandit_flutter_datacapture_barcode/Sources/scandit_flutter_datacapture_barcode/**/*.{h,m,swift}"
  s.requires_arc            = true

  s.dependency "Flutter"
  s.dependency "scandit_flutter_datacapture_core", "= #{version}"

  # Only add native framework dependency when not using SPM
  # SPM handles these dependencies via Package.swift
  unless spm_enabled
  s.dependency "scandit-datacapture-frameworks-barcode", '= 8.3.1'
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES", "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "i386" }
end
