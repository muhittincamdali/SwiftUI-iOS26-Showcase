Pod::Spec.new do |s|
  s.name             = 'SwiftUIiOS26Showcase'
  s.version          = '1.0.0'
  s.summary          = 'Showcase of iOS 26 SwiftUI features and capabilities.'
  s.description      = <<-DESC
    SwiftUIiOS26Showcase demonstrates all new iOS 26 SwiftUI features.
    Includes examples for new views, modifiers, animations, and APIs
    with best practices and migration guides.
  DESC

  s.homepage         = 'https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/SwiftUI-iOS26-Showcase.git', :tag => s.version.to_s }

  s.ios.deployment_target = '18.0'

  s.swift_versions = ['6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'SwiftUI'
end
