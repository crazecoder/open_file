#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'open_file_ios'
  s.version          = '1.0.3'
  s.summary          = 'The iOS implementation of open_file.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://github.com/crazecoder/open_file/tree/master/open_file_ios'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'crazecoder' => '21527312@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'open_file_ios/Sources/open_file_ios/**/*.{h,m}'
  s.public_header_files = 'open_file_ios/Sources/open_file_ios/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '12.0'
end

