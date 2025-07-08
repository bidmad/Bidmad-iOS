# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'BidmadSDKTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod "BidmadSDK", "6.12.4"
  pod "OpenBiddingHelper", "6.12.3"

  pod "BidmadAdFitAdapter", "3.12.7.11.0"
  pod "BidmadAdmixerAdapter", "2.0.2.11.1"
  pod "BidmadAppLovinAdapter", "13.3.1.11.0"
  pod "BidmadFyberAdapter", "8.3.7.11.0"
  pod "BidmadGoogleAdManagerAdapter", "12.6.0.11.0"
  pod "BidmadGoogleAdMobAdapter", "12.6.0.11.0"
  pod "BidmadMobwithAdapter", "1.0.0.11.2"
  pod "BidmadORTBAdapter", "1.0.0.11.2"
  pod "BidmadPangleAdapter", "7.2.0.5.11.0"
  pod "BidmadTaboolaAdapter", "3.8.33.11.2"
  pod "BidmadTeadsAdapter", "5.2.0.11.2"
  pod "BidmadUnityAdsAdapter", "4.15.0.11.0"
  pod "BidmadVungleAdapter", "7.5.1.11.0"
  pod "BidmadPartners/AdMobBidding", "1.0.7"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
