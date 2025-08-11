# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'BidmadSDKTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod "BidmadSDK", "6.13.2"
  pod "OpenBiddingHelper", "6.13.2"

  pod "BidmadAdFitAdapter", "3.12.7.12.1"
  pod "BidmadAdmixerAdapter", "2.0.2.12.1"
  pod "BidmadAppLovinAdapter", "13.3.1.12.1"
  pod "BidmadFyberAdapter", "8.3.7.12.1"
  pod "BidmadGoogleAdManagerAdapter", "12.6.0.12.1"
  pod "BidmadGoogleAdMobAdapter", "12.6.0.12.1"
  pod "BidmadMobwithAdapter", "1.0.0.12.1"
  pod "BidmadORTBAdapter", "1.0.0.12.1"
  pod "BidmadPangleAdapter", "7.2.0.5.12.1"
  pod "BidmadTaboolaAdapter", "3.8.33.12.1"
  pod "BidmadTeadsAdapter", "5.2.0.12.1"
  pod "BidmadUnityAdsAdapter", "4.15.0.12.1"
  pod "BidmadVungleAdapter", "7.5.1.12.1"
  pod "BidmadPartners/AdMobBidding", "1.0.7"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
