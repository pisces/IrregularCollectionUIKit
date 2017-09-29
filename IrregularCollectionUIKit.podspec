#
# Be sure to run `pod lib lint IrregularCollectionUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IrregularCollectionUIKit'
  s.version          = '2.0.0'
  s.summary          = 'Irregular Collection View Layout and Controller.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Irregular Collection View Layout and Controller'
  s.homepage         = 'https://github.com/pisces/IrregularCollectionUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Steve Kim' => 'hh963103@gmail.com' }
  s.source           = { :git => 'https://github.com/pisces/IrregularCollectionUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'IrregularCollectionUIKit/Classes/**/*'
  
end
