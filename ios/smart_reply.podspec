#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint smart_reply.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'smart_reply'
  s.version          = '0.0.1'
  s.summary          = 'Generate relevant replies to messages using MLKit.'
  s.description      = <<-DESC
Generate relevant replies to messages using MLKit.
                       DESC
  s.homepage         = 'http://github.com/kirpal/smart_reply'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kirpal Demian' => 'demian@kirp.al' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'GoogleMLKit/SmartReply'
  s.static_framework = true
  s.ios.deployment_target  = '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
