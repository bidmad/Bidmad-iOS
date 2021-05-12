# BidmadSDK iOS
## Integrated App Monetization Solution for Mobile Apps by all Publishers

1. Introduction
    - This document will guide you through the overall setups and interfaces of BidmadSDK. Currently, Bidmad uses the following ad network platforms,
        - GoogleManager (Banner, Interstitial, Reward)
        - GoogleAdmob (Banner, Interstitial, RewardVideo)
        - AppLovin (RewardVideo)
        - UnityAds (RewardVideo, Banner)
        - Facebook Audience Network (Banner, Interstitial, Reward)
        - ADOPAtom (Interstitial, RewardVideo)
        - Tapjoy (Offerwall)
    - BidmadSDK iOS offers Banner <320Ⅹ50, 300Ⅹ250>, Interstitial, Reward Video, Offerwall Ads.

## BidmadSDK Installation Guide

1. Development Environment
    - Xcode 12.0
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. SDK설치 방법
    - **(Highly Recommended)** Installation through CocoaPods

        Add the following code in your project Podfile.

        ```
        platform :ios, "10.0"

        target "Runner" do
         use_frameworks!
         pod "BidmadSDK", "2.6.3"
        ```

        Followed by entering the following command in Terminal.

        ```
        pod install
        ```

    - **(Not Recommeded)** Manual Framework Embedding Method
        1. Please add the framework and bundle into your project, just as the image below.

            ![BidmadSDK%20Interface%20Guide%200fab5e4337eb4ee291be98969dbc7a78/Screenshot_of_Xcode_(2021-05-12_3-10-19_PM).png](https://drive.google.com/uc?export=view&id=1t63jauRPErG2Nf5MUM_mcf1KFpp4ecC_)

        2. Add BidmadSDK.framework to Embedded Binaries  
        3. Add "bidmad_asset.bundle" to Copy Bundle Resources under Build Phases tab
3. info.plist Setting

    ```
    ...
    <key>GADApplicationIdentifier</key> 
    <string>ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx</string>
    <key>SKAdNetworkItems</key>
    <array>
      <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>xxxxxxxxxx.skadnetwork</string>
      </dict>
      <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>xxxxxxxxxx.skadnetwork</string>
      </dict>
      ...
    </array>
    <key>NSUserTrackingUsageDescription</key>
    <string>This application uses personal info for ad targeting.</string>
    <key>NSAppTransportSecurity</key> 
    <dict>
      <key>NSAllowsArbitraryLoads</key> 
      <true/> 
    </dict>
    ...
    ```

4. Build Settings 
    1. CocoaPods
        - Set 'Enable Bitcode' to No
    2. Manual Framework Import
        - Set 'Enable Bitcode' to No
        - Add -ObjC Flag to Other Linker Flag
        - Set 'Allow Non-Modular Includes In Framework Modules' to Yes

## BidmadSDK Interface Guide

1. Banner Ad

    ObjC Example

    ```
    @interface BannerViewController : UIViewController<BIDMADBannerDelegate>
    ...
    banner = [[BIDMADBanner alloc] initWithParentViewController:self rootView:self.BannerContainer bannerSize:banner_320_50];
    [banner setZoneID:@"Your Zone Id"];
    [banner setDelegate:self];
    [banner setRefreshInterval:60];
    [banner requestBannerView]; // Request to load and view the banner
    ...
    [banner removeAds] // Remove Banner from UIView
    ```

    Swift Example

    ```
    class BannerController: UIViewController, BIDMADBannerDelegate {
      var banner: BIDMADBanner

      override func viewDidLoad() {
        let banner = BIDMADBanner(parentViewController: self, rootView: bannerContainer, bannerSize: banner_320_50)!
        banner.zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        banner.refreshInterval = 60
        banner.delegate = self
        banner.requestView() // Request to load and view the banner
      }

      func removeBanner() {
        banner.removeAds() // Remove Banner from UIView
      }
      ...
    }
    ```

2. Interstitial Ad

    ObjC Example

    ```
    @interface InterstitialViewController : UIViewController<BIDMADInterstitialDelegate>
    ...
    interstitial = [[BIDMADInterstitial alloc] init];
    [interstitial setParentViewController:self];
    [interstitial setZoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [interstitial setDelegate:self];
    ...
    [interstitial loadInterstitialView];
    ...
    if([interstitial isLoaded]){
      [interstitial showInterstitialView];
    }
    ```

    Swift Example

    ```
    class InterstitialController: UIViewController, BIDMADInterstitialDelegate {
      var interstitial: BIDMADInterstitial
       
      override func viewDidLoad() {
        interstitial = BIDMADInterstitial()!
        interstitial.zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        interstitial.delegate = self
        interstitial.parentViewController = self
        interstitial.loadView()
      }

      func showAd() {
        if (interstitial.isLoaded) {
          interstitial.showView()
        }
      }
      ...
    }
    ```

3. Reward Video Ad

    ObjC Example

    ```
    @interface RewardViewController : UIViewController<BIDMADOpenBiddingRewardVideoDelegate>
    ...
    rewardVideo = [[BIDMADRewardVideo alloc]init];
    [rewardVideo setZoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [rewardVideo setParentViewController:self];
    [rewardVideo setDelegate:self];
    ...
    [rewardVideo loadRewardVideo];
    ...
    if ([rewardVideo isLoaded]) {
      [rewardVideo showRewardVideo];
    }
    ```

    Swift Example

    ```
    class RewardVideoController: UIViewController, BIDMADRewardVideoDelegate {
      var rewardVideo: BIDMADRewardVideo

      override func viewDidLoad() {
        rewardVideo = BIDMADRewardVideo()!
        rewardVideo.zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        rewardVideo.delegate = self
        rewardVideo.parentViewController = self
        rewardVideo.load()
      }

      func showAd() {
        if (rewardVideo.isLoaded) {
          rewardVideo.show()
        }
      }
      ...
    }
    ```

4. Offerwall Ad

    ObjC Example

    ```
    @interface OfferwallController : UIViewController<BIDMADOfferwallDelegate>
    ...
    offerwall = [[BIDMADOfferwall alloc]initWithZoneId:@"Your Zone Id"];
    [offerwall setParentViewController:self];
    [offerwall setDelegate:self];
    ...
    [offerwall loadOfferwall];
    ...
    if ([offerwall isLoaded]) {
      [offerwall showOfferwall];
    }
    ...
    [offerwall getCurrencyBalance];
    ...
    [offerwall spendCurrency:amount];
    ```

    Swift Example

    ```
    class bannerController: UIViewController, BIDMADBannerDelegate, BIDMADOfferwallDelegate {
      var offerwall: BIDMADOfferwall
      
      override func viewDidLoad() {
        offerwall = BIDMADOfferwall(zoneId: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")!
        offerwall.parentViewController = self
        offerwall.delegate = self
        offerwall.load();

      }
        
      func showAd() {
        if (offerwall.isLoaded) {
          offerwall.show()
        }
      }

      func currencyAction() {
        let spenditureAmount = 2
        offerwall.getCurrencyBalance()
        ...
        offerwall.spendCurrency(Int32(spenditureAmount))
      }
    }
    ```

5. Class Reference
    1. BIDMADBanner

        — (id)initWithParentViewController:(UIViewController *)parentVC rootView:(UIView *)view bannerSize:(bannerSizeType) bannerTypeParam;

        - Banner Ad Initialization Method

        — (void)requestBannerView;

        - Banner Ad Request Method

        — (void)removeAds;

        - Banner Ad Removal Method

        @property (nonatomic) bannerSizeType bannerType;

        - Banner Size Types, two types are as follows
        - banner_320_50
        - banner_300_250

        @property (nonatomic, strong) NSString* zoneID;

        - Banner Ad ZoneId
    2. BIDMADBannerDelegate

        — (void)BIDMADBannerAllFail:(BIDMADBanner *)core;

        - If error, the method gets called 

        — (void)BIDMADBannerLoad:(BIDMADBanner *)core;

        - If loaded, the method gets called

        — (void)BIDMADBannerClick:(BIDMADBanner*) core;

        - If clicked, the method gets called
    3. BIDMADInterstitial

        — (id)init;

        - Interstitial Ad initialization

        — (void)loadInterstitialView;

        - Interstitial Ad Request and load method

        — (void)showInterstitialView;

        - Show the interstitial Ad

        @property (nonatomic, strong) UIViewController* parentViewController;

        - UIViewController property, this property needs to be set with your UIViewController

        @property (nonatomic, strong) NSString* zoneID;

        - Interstitial Zone ID
    4. BIDMADInterstitialDelegate

        — (void)BIDMADInterstitialAllFail:(BIDMADInterstitial *)core;

        - If error, the method gets called

        — (void)BIDMADInterstitialLoad:(BIDMADInterstitial *)core;

        - If request and loading are done, the method gets called

        — (void)BIDMADInterstitialClose:(BIDMADInterstitial *)core;

        - When the ad is closed, the method gets called

        — (void)BIDMADInterstitialShow:(BIDMADInterstitial *)core;

        - When showing the interstitial ad, the method gets called 
    5. BIDMADReward

        — (id)init;

        - Initialization method

        — (void)loadRewardVideo;

        - Reward Ad Request method

        — (void)showRewardVideo;

        - Requested reward ad show method

        @property (nonatomic, strong) UIViewController* parentViewController;

        - UIViewController Settings Property

        @property (nonatomic, strong) NSString* zoneID;

        - Reward Video ZONE ID
    6. BIDMADRewardVideoDelegate

        — (void)BIDMADRewardVideoAllFail:(BIDMADRewardVideo *)core;

        - Called when reward ad error

        — (void)BIDMADRewardVideoLoad:(BIDMADRewardVideo *)core;

        -  Called if the ad is loaded successfully after requesting a reward ad

        — (void)BIDMADRewardVideoShow:(BIDMADRewardVideo *)core;

        - Called when reward ad is shown.

        — (void)BIDMADRewardVideoClose:(BIDMADRewardVideo *)core;

        - Called when reward ad is closed

        — (void)BIDMADRewardVideoSucceed:(BIDMADRewardVideo *)core;

        - Called when the user completed watching the reward video 

        — (void)BIDMADRewardSkipped:(BIDMADRewardVideo *) core;

        - Called if reward conditions are not met
    7. BIDMADOfferwall

        — (id)initWithZoneId:(NSString *)zoneId;

        - Offerwall Initialization

        + (BOOL)isSDKInit;

        - Checks if the SDK for Offerwall was initialized

        — (void)loadOfferwall;

        - Offerwall Ad Request and Load method

        — (void)showOfferwall;

        - Show the loaded ad

        — (void)getCurrencyBalance;

        - Call the Offerwall SDK to check the current currency balance

        — (void)spendCurrency:(int)amount;

        - Offerwall Currency Consumption method

        @property (nonatomic, strong) UIViewController* parentViewController;

        - UIViewController Setting Property

        @property (nonatomic, strong) NSString* zoneID;

        - Offerwall ZONE ID
    8. BIDMADOfferwallDelegate

        — (void)BIDMADOfferwallInitSuccess:(BIDMADOfferwall *)core;

        - Called when successfully initialized Offerwall Ad SDK

        — (void)BIDMADOfferwallInitFail:(BIDMADOfferwall *)core error:(NSString *)error;

        - Called when the Offerwall Ad SDK fails to be initialized

        — (void)BIDMADOfferwallLoadAd:(BIDMADOfferwall *)core;

        - Called when Offerwall ads are loaded successfully

        — (void)BIDMADOfferwallShowAd:(BIDMADOfferwall *)core;

        - Called when Offerwall ad is shown

        — (void)BIDMADOfferwallFailedAd:(BIDMADOfferwall *)core;

        - Called when Offerwall ad load fails

        — (void)BIDMADOfferwallCloseAd:(BIDMADOfferwall *)core;

        - Called when closing an Offerwall ad

        — (void)BIDMADOfferwallGetCurrencyBalanceSuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance;

        - Called when Offerwall advertising currency is loaded successfully 

        — (void)BIDMADOfferwallGetCurrencyBalanceFail:(BIDMADOfferwall *)core error:(NSString *)error;

        - Called when Offerwall advertising currency is loaded unsuccessfully

        — (void)BIDMADOfferwallSpendCurrencySuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance;

        - Called when the currency was consumed successfully 

        — (void)BIDMADOfferwallSpendCurrencyFail:(BIDMADOfferwall *)core error:(NSString *)error;

        - Called when spending the currency was failed
6. etc
    1. Please set the delegate property before requesting an ad from banner or interstitial.
    2. Banner refresh time must be 10 seconds or above.
    3. BIDMADSetting's default setting values
        - age = 20;
        - gender = “ ”;
        - keyword = “ ”;
        - longtitude = 0;
        - latitude = 0;
        - refreshInterval = 60;
7. Information for common interface in BidmadSDK
    1. App Tracking Transparency and iOS14

        [bidmad/SDK](https://github.com/bidmad/SDK/wiki/Preparing-for-iOS-14%5BKOR%5D)

    2. Setting Test Device ID for Google Ad Networks

        ```
        // ObjC
        [BIDMADSetting.sharedInstance setTestDeviceId:"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"];

        // Swift
        BIDMADSetting.sharedInstance().testDeviceId = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        ```

    3. GDPR for Google and Non-Google Ad Networks

        [bidmad/SDK](https://github.com/bidmad/SDK/wiki/iOS-GDPR-Guide-%5BKOR%5D)

8. Change Logs
    1. 2019.07.11
        - ARPM Added
    2. 2020.02.18
        - Admob mediation Added
    3. 2020.05.13
        - MoPub 추가
    4. 4. 2020.05.18
        - Network List Edited
    5. 2020.05.25
        - Test Device Added
    6. 2020.09.09
        - IronSource Added
        - Country-targetted Mediation Added
    7. 2020.09.15
        - BIDMADBanner Interface Edited
    8. 2020.09.22
        - SDK Update Process in preparation of iOS 14.0  
    9. 2020.11.09
        - AdFit, UnityAds, AdColony Banner added
    10. 2020.11.23
        - Minimum iOS requirement is set to iOS 11
    11. 2021.02.16
        - Partially deprecated some interfaces in BidmadSetting
        - Offerwall ad type supported
    12. 2021.05.12
        - BidmadSDK CocoaPods supported
