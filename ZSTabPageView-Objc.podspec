#
# Be sure to run `pod lib lint ZSTabPageView-Objc.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZSTabPageView-Objc'
  s.version          = '0.2.0'
  s.summary          = '标签和内容联动View'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
1. 顶部标签切换内容联动
2. ScrollView多级嵌套联动，可定义header和悬浮Tab
                       DESC

  s.homepage         = 'https://github.com/zhangsen093725/ZSTabPageView-Objc'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author           = { 'Josh' => '376019018@qq.com' }
  s.source           = { :git => 'https://github.com/zhangsen093725/ZSTabPageView-Objc.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZSTabPageView-Objc/Classes/**/*'
  
  s.public_header_files = 'ZSTabPageView-Objc/Classes/Public/**/*.h'
  
  # s.resource_bundles = {
  #   'ZSTabPageView-Objc' => ['ZSTabPageView-Objc/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
