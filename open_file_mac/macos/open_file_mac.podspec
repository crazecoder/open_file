#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint open_file.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'open_file_mac'
  s.version          = '1.0.3'
  s.summary          = 'The MacOS implementation of open_file.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/crazecoder/open_file/tree/master/open_file_mac'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'crazecoder' => '21527312@qq.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'open_file_mac/Sources/open_file_mac/**/*.swift'
  s.resource_bundles = {'open_file_mac_privacy' => ['open_file_mac/Sources/open_file_mac/Resources/PrivacyInfo.xcprivacy']}
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
