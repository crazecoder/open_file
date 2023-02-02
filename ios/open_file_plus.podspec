#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint open_file_plus.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'open_file_plus'
  s.version          = '1.0.0'
  s.summary          = 'A plug-in that can call native APP to open files with string result in flutter, support iOS(UTI) / android(intent) / PC(ffi) / web(dart:html)'
  s.description      = <<-DESC
A plug-in that can call native APP to open files with string result in flutter, support iOS(UTI) / android(intent) / PC(ffi) / web(dart:html)
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
