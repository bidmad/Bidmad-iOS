# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'BidmadSDKTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod "BidmadSDK", "7.0.0"
  pod "BidmadGoogleGDPRAdapter", "7.0.0"
  pod "OpenBiddingHelper", "7.0.0"

  pod "BidmadAdFitAdapter", "3.18.3.14.0"
  pod "BidmadAdmixerAdapter", "2.3.2.14.0"
  pod "BidmadAppLovinAdapter", "13.6.2.14.0"
  pod "BidmadFyberAdapter", "8.4.6.14.0"
  pod "BidmadGoogleAdManagerAdapter", "13.2.0.14.0"
  pod "BidmadGoogleAdMobAdapter", "13.2.0.14.0"
  pod "BidmadMobwithAdapter", "2.0.0.14.0"
  pod "BidmadORTBAdapter", "1.0.0.14.0"
  pod "BidmadPangleAdapter", "7.9.0.8.14.0"
  pod "BidmadTaboolaAdapter", "3.9.12.14.0"
  pod "BidmadTeadsAdapter", "6.1.0.14.0"
  pod "BidmadUnityAdsAdapter", "4.17.0.14.0"
  pod "BidmadVungleAdapter", "7.7.2.14.0"
  pod "BidmadPartners/AdMobBidding", "1.0.10"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
