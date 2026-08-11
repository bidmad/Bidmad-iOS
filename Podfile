# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'BidmadSDKTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod "BidmadSDK", "7.0.1"
  pod "BidmadGoogleGDPRAdapter", "7.0.1"
  pod "OpenBiddingHelper", "7.0.1"

  pod "BidmadAdFitAdapter", "3.18.3.14.1"
  pod "BidmadAppLovinAdapter", "13.6.2.14.1"
  pod "BidmadFyberAdapter", "8.4.6.14.1"
  pod "BidmadGoogleAdManagerAdapter", "13.2.0.14.1"
  pod "BidmadGoogleAdMobAdapter", "13.2.0.14.1"
  pod "BidmadMobwithAdapter", "2.0.0.14.1"
  pod "BidmadORTBAdapter", "1.0.0.14.1"
  pod "BidmadPangleAdapter", "7.9.0.8.14.1"
  pod "BidmadPremiumAdsGoogleAdapter", "1.0.6.14.1"
  pod "BidmadTaboolaAdapter", "3.9.12.14.1"
  pod "BidmadTeadsAdapter", "6.1.0.14.1"
  pod "BidmadUnityAdsAdapter", "4.17.0.14.1"
  pod "BidmadVungleAdapter", "7.7.2.14.1"
  pod "BidmadPartners/AdMobBidding", "1.0.13"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
