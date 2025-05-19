# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'BidmadSDKTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod "BidmadSDK", "6.12.2"
  pod "OpenBiddingHelper", "6.12.1"

  pod "BidmadAdFitAdapter", "3.12.7.11.0"
  pod "BidmadAdmixerAdapter", "2.0.2.11.1"
  pod "BidmadAppLovinAdapter", "13.0.0.11.0"
  pod "BidmadFyberAdapter", "8.3.2.11.0"
  pod "BidmadGoogleAdManagerAdapter", "11.10.0.11.0"
  pod "BidmadGoogleAdMobAdapter", "11.10.0.11.2"
  pod "BidmadMobwithAdapter", "1.0.0.11.2"
  pod "BidmadORTBAdapter", "1.0.0.11.2"
  pod "BidmadPangleAdapter", "6.2.0.7.11.0"
  pod "BidmadPubmaticAdapter", "3.2.0.11.0"
  pod "BidmadTaboolaAdapter", "3.8.33.11.2"
  pod "BidmadTeadsAdapter", "5.2.0.11.2"
  pod "BidmadUnityAdsAdapter", "4.12.3.11.0"
  pod "BidmadVungleAdapter", "7.4.1.11.0"
  pod "BidmadPartners/AdMobBidding", "1.0.6"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
