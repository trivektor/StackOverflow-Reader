# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-cocoapods'
require 'afmotion'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Stack Overflow'
  app.identifier = 'com.stackoverflowmotion'
  app.device_family = [:iphone, :ipad]
  app.sdk_version = '7.0'
  app.provisioning_profile = ENV['MOTION_PROVISIONING_PROFILE']
  app.codesign_certificate = ENV['MOTION_CODESIGN_CERTIFICATE']
  app.detect_dependencies = false
  app.prerendered_icon = true

  # Frameworks
  %w(
    QuartzCore
    Security
    CoreAnimation
  ).each { |framework| app.frameworks << framework }

  # Keychain
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  # Fonts
  app.fonts = ['FontAwesome.otf']

  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false

  app.pods do
    pod 'AFNetworking'
    pod 'SSKeychain'
    pod 'FontAwesomeIconFactory'
    pod 'FontAwesome+iOS'
    pod 'MWFeedParser'
    pod 'RESideMenu'
    pod 'GRMustache'
    pod 'NSData+Base64'
    pod 'DDURLParser'
    pod 'MRProgress'
  end

end