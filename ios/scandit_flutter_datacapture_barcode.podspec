# TODO: https://jira.scandit.com/browse/SDC-5384

require "yaml"

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))

Pod::Spec.new do |s|
  s.name                    = pubspec['name']
  s.version                 = pubspec['version']
  s.summary                 = pubspec['description']
  s.homepage                = pubspec['homepage']
  s.license                 = { :file => '../LICENSE' }
  s.author                  = { 'Scandit' => 'support@scandit.com' }
  s.platforms               = { :ios => "13.0" }
  s.source                  = { :path => '.' }
  s.swift_version           = '4.0'
  s.source_files            = 'Classes/**/*.{h,m,swift}'
  s.requires_arc            = true
  s.dependency 'ScanditBarcodeCapture', '= 6.17.1'

  s.dependency 'Flutter'
  s.dependency 'scandit_flutter_datacapture_core'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
