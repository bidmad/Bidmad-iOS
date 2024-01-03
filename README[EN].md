# BidmadSDK
### Shortcuts
1. [SDK Installation Guide](#bidmadsdk-installation-guide)
    - [Development Environment](#development-environment)
    - [SDK Installation Guide](#installation-guide)
2. [BidmadSDK Interface Guide](#bidmadsdk-interface-guide)
    - [App Configuration and Migration](#app-configuration-and-migration)
    - [BidmadSDK Initialization](#bidmadsdk-initialization)
    - [Banner Ad](#banner-ad)
    - [Interstitial Ad](#interstitial-ad)
    - [Rewarded Video Ads](#rewarded-video-ads)
    - [App Open Ad](#app-open-ad)
    - [Native Ad](#native-ad)
    - [Google Ad Network Test Device Setting](#google-ad-network-test-device-setting)
3. [References](#references)
4. [Download the Lastest Bidmad Sample](https://github.com/bidmad/Bidmad-iOS/archive/refs/heads/main.zip)
---

## BidmadSDK Installation Guide

#### Development Environment
- Xcode 14.1 version (Xcode minimum version of 14.1 required)
- BASE SDK : iOS
- iOS Deployment Target : 12.0
#### Installation Guide
1. Add the following code inside the Podfile

```
platform :ios, "12.0"

target "Runner" do
  use_frameworks!
  
  # NECESSARY
  pod 'BidmadSDK', '6.5.0'
  pod 'OpenBiddingHelper', '6.5.0'
  pod 'BidmadGoogleAdMobAdapter', '10.12.0.1'
  pod 'BidmadGoogleAdManagerAdapter', '10.12.0.1'
  pod 'BidmadAppLovinAdapter', '11.11.3.1'
  pod 'BidmadUnityAdsAdapter', '4.8.0.1'
  pod 'BidmadPangleAdapter', '5.3.1.0.1'
  pod 'BidmadFyberAdapter', '8.2.4.1'
  pod 'BidmadVungleAdapter', '7.1.0.1'
  pod 'BidmadPubmaticAdapter', '3.2.0.1'
  pod 'BidmadAdColonyAdapter', '4.9.0.1'
  pod 'BidmadADOPCoupangAdapter', '1.0.0.1'
  pod 'BidmadPartners/AdMobBidding', '1.0.2'
  
  # OPTIONAL
  pod 'BidmadTeadsAdapter', '5.0.27.1'
  pod 'BidmadAtomAdapter', '1.0.0.1'
  pod 'BidmadAdFitAdapter', '3.12.7.1'
  pod 'BidmadIronSourceAdapter', '7.5.0.0.1'
```

  * From version 6.4.0 onwards, BidmadAdapterFNC, BidmadAdapterFC, and BidmadAdapterDynamic are not supported. Users who wish to update from version 6.3.X or below to version 6.4.0 or above should remove the dependencies for "BidmadAdapterFNC, BidmadAdapterFC, BidmadAdapterDynamic" and add the adapter by including the dependencies mentioned above.

2. Enter the following command in Terminal

```
pod install
```
    
3. Build Settings ( Target → Build Settings ) <br>
    - Set Enable Bitcode to NO<br>
        ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>

## BidmadSDK Interface Guide

### App Configuration and Migration<br>
Prior to the initial configuration of the app, when updating from version 4.6.0.1 or lower to version 5.0.0 [API Migration Guide](https://github.com/bidmad/Bidmad-iOS/wiki/v5.0.0-API-Migration-Guide-%5BEN%5D) to update the app. After that, go through the process of adding BidmadAppKey and initializeSdk method inside info.plist as guided below.<br>

For users of native ad interface updating from v5.3.0 or lower to v6.0.0 or higher, please refer to [NativeAd Migration Guide 6.0.0](https://github.com/bidmad/Bidmad-iOS/wiki/Native-Ad-Migration-to-v6.0.0%5BENG%5D) for your app updates. 

For users of app open ad and native ad interface updating from v6.3.5 or lower to v6.4.0 or higher, please refer to [AppOpen and NativeAd Migration Guide for 6.4.0](https://github.com/bidmad/Bidmad-iOS/wiki/AppOpen-and-NativeAd-Migration-Guide-for-6.4.0-%5BKOR%5D) for your app updates.

Include the following key in your Xcode project info.plist :<br>
1. iOS App Key identified in ADOP Insight (refer to "[Find your App Key](https://github.com/bidmad/SDK/wiki/Find-your-app-key%5BEN%5D)" guide) <br>

```
<key>BidmadAppKey</key>
<string>xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx</string>
```

2. iOS Google AdMob ID identified in AdMob Dashboard UI (refer to "[Find your App Key](https://github.com/bidmad/SDK/wiki/Find-your-app-key%5BEN%5D)" guide) <br>

```
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx</string>
```

3. SKAdNetworkItems key containing SKAdNetworkIdentifier values for ad networks supported by BidmadSDK (refer to [Preparing for iOS 14](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BENG%5D))<br>

```
<key>SKAdNetworkItems</key>
<array>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>xxxxxxxxxx.skadnetwork</string>
        ...
    </dict>
</array>
```

### BidmadSDK Initialization<br>
Performs tasks required to run BidmadSDK. The SDK won't allow ads to load unless you call the initializeSdk method.<br>
It is recommended to initialize only once when the app is launched. The following is an example of how to call the initializeSdk method.<br>

```
// Objective C
[BidmadCommon initializeSdk];

// Swift
BidmadCommon.initializeSdk()
```

Also, you can be receiving the initialization success or failure callback w ith the following interface.<br>

```
// Objective C
[BidmadCommon initializeSdkWithCompletionHandler:^(BOOL isInitialized) {
    NSLog(@"Bidmad Sample App: Initialized %@", isInitialized ? @"YES" : @"NO");
}];

// Swift
BidmadCommon.initializeSdk { isInitialized in
    print("Bidmad Sample App: \(isInitialized)")
}
```

### Banner Ad
1. Add a UIView to display the banner on the UIViewController (UIView bannerContainer).
2. After setting the banner Initialize / ZoneID / Delegate, call RequestBannerView to load and display the banner.

<details markdown="1">
<summary>Sample Code (Load)</summary>
<br>

```
// Objective C

@import OpenBiddingHelper;

@interface BannerViewController : UIViewController<BIDMADOpenBiddingBannerDelegate> {
    BidmadBannerAd *bannerAd;
}
__weak IBOutlet UIView *bannerContainer;
@end

@implementation BannerViewController

- (void)viewDidLoad {

    // Please set the Zone ID before calling a banner ad.
    NSString *zoneID = @"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    bannerAd = [[BidmadBannerAd alloc] initWith:self containerView:self.BannerContainer zoneID:zoneID];
    bannerAd.delegate = self;
    [bannerAd setRefreshInterval:[@60 integerValue]];
    
    [bannerAd load];
}

// Swift

import OpenBiddingHelper

class BannerViewController: UIViewController, BIDMADOpenBiddingBannerDelegate {
    var bannerAd: BidmadBannerAd!
    @IBOutlet weak var bannerContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerAd = BidmadBannerAd(self, containerView: bottomView, zoneID: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
        bannerAd.delegate = self
        bannerAd.setRefreshInterval(60)
        bannerAd.load()
    }
}
```
</details>

<details markdown="1">
<summary>Sample Code (Callback)</summary>
<br>

```
// Objective C

- (void)onLoadAd:(OpenBiddingBanner *)bidmadAd {
    NSLog(@"Load")
}

- (void)onClickAd:(OpenBiddingBanner *)bidmadAd {
    NSLog(@"Click")
}

- (void)onLoadFailAd:(OpenBiddingBanner *)bidmadAd error:(NSError * _Nonnull)error {
    NSLog(@"LoadFail")
}

// Swift

func onLoadAd(_ bidmadAd: OpenBiddingBanner) {
    print("ad is loaded")
}

func onLoadFailAd(_ bidmadAd: OpenBiddingBanner, error: Error) {
    print("ad failed to load with error \(error.localizedDescription)")
}
func onClickAd(_ bidmadAd: OpenBiddingBanner) {
    print("ad is clicked")
}
```
</details>

### Interstitial Ad
1. Call the load method before displaying the interstitial ad.
2. After receiving the onLoadAd callback, call the show(on:) method to display the preloaded interstitial ad. 

<details markdown="1">
<summary>Sample Code (Load)</summary>
<br>

```
// Objective C

@import OpenBiddingHelper;

@interface InterstitialViewController () <BIDMADOpenBiddingInterstitialDelegate> {
    BidmadInterstitialAd *interstitialAd;
}
@end

@implementation InterstitialViewController
- (void)viewDidLoad {
    
    NSString *zoneID = @"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    interstitialAd = [[BidmadInterstitialAd alloc] initWithZoneID:zoneID];
    [interstitialAd setDelegate: self];
}

-(void)loadAd {
    [interstitialAd load];
}
...
-(void)showAd {
    [interstitialAd showOnViewController:self];
}

// Swift

import OpenBiddingHelper

class InterstitialController: UIViewController, BIDMADOpenBiddingInterstitialDelegate {
    static let interstitialZoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    let interstitialAd = BidmadInterstitialAd(zoneID: interstitialZoneID)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitialAd.delegate = self
    }
  
    func loadAd() {
        interstitialAd.load()
    }

    func showAd() {
        interstitialAd.show(on: self)
    }
}
```
</details>

<details markdown="1">
<summary>Sample Code (Callback)</summary>
<br>

```
// Objective C

- (void)onLoadAd:(OpenBiddingInterstitial *)bidmadAd {
    NSLog(@"Load");
}

- (void)onLoadFailAd:(OpenBiddingInterstitial *)bidmadAd error:(NSError * _Nonnull)error {
    NSLog(@"Load Fail");
}

- (void)onShowAd:(OpenBiddingInterstitial *)bidmadAd {
    NSLog(@"Show");
}

- (void)onClickAd:(OpenBiddingInterstitial *)bidmadAd {
    NSLog(@"Click");
}

- (void)onCloseAd:(OpenBiddingInterstitial *)bidmadAd {
    NSLog(@"Close");
}

// Swift

func onLoadAd(_ bidmadAd: OpenBiddingInterstitial) {
    print("ad is loaded")
}

func onLoadFailAd(_ bidmadAd: OpenBiddingInterstitial, error: Error) {
    print("ad failed to load with error \(error.localizedDescription)")
}

func onShowAd(_ bidmadAd: OpenBiddingInterstitial) {
    print("ad is shown")
}

func onClickAd(_ bidmadAd: OpenBiddingInterstitial) {
    print("ad is clicked")
}

func onCloseAd(_ bidmadAd: OpenBiddingInterstitial) {
    print("ad is closed")
}
```
</details>

### Rewarded Video Ads
1. Call the load method before displaying rewarded ads.
2. After receiving the onLoadAd callback, call the show(on:) method to display the preloaded rewarded ad.
3. Reward the user according to the onSkipAd (user skipped the ad) or onCompleteAd (user is eligible for reward) callback.

<details markdown="1">
<summary>Sample Code (Load)</summary>
<br>

```
// Objective C
@import OpenBiddingHelper;

@interface RewardViewController () <BIDMADOpenBiddingRewardVideoDelegate> {
    BidmadRewardAd *rewardAd;
}
@end

@implementation RewardViewController

- (void)viewDidLoad {
    
    NSString *zoneID = @"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    rewardAd = [[BidmadRewardAd alloc] initWithZoneID:zoneID];
    rewardAd.delegate = self;
}

-(void)loadReward {
    [rewardAd load];
}
   

-(void)showReward {
    [rewardAd showOnViewController:self];
}

// Swift

import OpenBiddingHelper

class RewardVideoController: UIViewController, BIDMADOpenBiddingRewardVideoDelegate {
    static let rewardZoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    let rewardAd = BidmadRewardAd(zoneID: rewardZoneID)

    override func viewDidLoad() {
        super.viewDidLoad()
    
        rewardAd.delegate = self
    }
    
    func loadAd() {
        rewardAd.load()
    }
  
    func showAd() {
        rewardAd.show(on: self)
    }
}
```
</details>

<details markdown="1">
<summary>Sample Code (Callback)</summary>
<br>

```
// Objective C

- (void)onLoadAd:(OpenBiddingRewardVideo *)bidmadAd {
    NSLog(@"Load");
}

- (void)onLoadFailAd:(OpenBiddingRewardVideo *)bidmadAd error:(NSError * _Nonnull)error {
    NSLog(@"Load Fail");
}

- (void)onShowAd:(OpenBiddingRewardVideo *)bidmadAd {
    NSLog(@"Show");
}

- (void)onClickAd:(OpenBiddingRewardVideo *)bidmadAd {
    NSLog(@"Click");
}

- (void)onCompleteAd:(OpenBiddingRewardVideo *)bidmadAd {
    NSLog(@"Complete");
}

- (void)onSkipAd:(OpenBiddingRewardVideo *)bidmadAd {
    NSLog(@"Skip");
}

- (void)onCloseAd:(OpenBiddingRewardVideo *)bidmadAd {
    NSLog(@"Close");
}

// Swift

func onLoadAd(_ bidmadAd: OpenBiddingRewardVideo) {
    print("ad is loaded")
}

func onLoadFailAd(_ bidmadAd: OpenBiddingRewardVideo, error: Error) {
    print("ad failed to load with error \(error.localizedDescription)")
}

func onShowAd(_ bidmadAd: OpenBiddingRewardVideo) {
    print("ad is shown")
}

func onClickAd(_ bidmadAd: OpenBiddingRewardVideo) {
    print("ad is clicked")
}

func onCompleteAd(_ bidmadAd: OpenBiddingRewardVideo) {
    print("ad reward is completed")
}

func onSkipAd(_ bidmadAd: OpenBiddingRewardVideo) {
    print("ad reward is skipped")
}

func onCloseAd(_ bidmadAd: OpenBiddingRewardVideo) {
    print("ad is closed")
}
```
</details>

### App Open Ad
App Open ads are an ad format that monetizes the app load screen when a user brings the app to the foreground. App Open ads feature the app logo at the top so users know they're using the app. BidmadSDK loads AppOpenAd directly at BidmadAppOpenAd init for easier App Open ad loading. Even after the user closes and reopens the app to view the ad, AppOpenAd will load the ad again.

<details markdown="1">
<summary>Sample Code (Load)</summary>
<br>

```
// Objective C

@interface AppOpenAdViewController () <OpenBiddingAppOpenAdDelegate>
@property (nonatomic, strong) BidmadAppOpenAd *appOpenAd;
@end

@implementation AppOpenAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appOpenAd = [[BidmadAppOpenAd alloc] initWith:self zoneID:@"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
    [self.appOpenAd setDelegate: self];
}

- (void)loadAd {
    [self.appOpenAd load];
}

- (void)showAd {
    if ([self.appOpenAd isLoaded]) {
        [self.appOpenAd showOnViewController:self];
    }
}

- (void)deregister {
    // Disable App Open Ad automatically showing once your app moves to foreground
    [self.appOpenAd deregisterForAppOpenAd];
}

@end

// Swift

import OpenBiddingHelper

class AppOpenAdViewController: UIViewController, OpenBiddingAppOpenAdDelegate {
    let appOpenAdZoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    var appOpenAd: BidmadAppOpenAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appOpenAd = BidmadAppOpenAd(self, zoneID: appOpenAdZoneID)
        appOpenAd.delegate = self
    }
    
    func loadAppOpenAd() {
        appOpenAd.load()
    }
    
    func showAppOpenAd() {
        if appOpenAd.isLoaded() {
            appOpenAd.show(on: self)
        }
    }
    
    func deregisterAppOpenAd() {
        appOpenAd.deregisterForAppOpenAd()
    }
}
```
</details>

<details markdown="1">
<summary>Sample Code (Callback)</summary>
<br>

```
- (void)onLoadAd:(OpenBiddingAppOpenAd *)bidmadAd {
    NSLog(@"Load");
}

- (void)onShowAd:(OpenBiddingAppOpenAd *)bidmadAd {
    NSLog(@"Show");
}

- (void)onClickAd:(OpenBiddingAppOpenAd *)bidmadAd {
    NSLog(@"Click");
}

- (void)onCloseAd:(OpenBiddingAppOpenAd *)bidmadAd {
    NSLog(@"Close");
}

- (void)onLoadFailAd:(OpenBiddingAppOpenAd *)bidmadAd error:(NSError * _Nonnull)error {
    NSLog(@"Load Fail");
}

// Swift

func onLoadAd(_ bidmadAd: OpenBiddingAppOpenAd) {
    print("ad is loaded")
}

func onLoadFailAd(_ bidmadAd: OpenBiddingAppOpenAd, error: Error) {
    print("ad failed to load with error \(error.localizedDescription)")
}

func onShowAd(_ bidmadAd: OpenBiddingAppOpenAd) {
    print("ad is shown")
}

func onClickAd(_ bidmadAd: OpenBiddingAppOpenAd) {
    print("ad is clicked")
}

func onCloseAd(_ bidmadAd: OpenBiddingAppOpenAd) {
    print("ad is closed")
}
```
</details>

### Native Ad
Native ads are ads that are designed and produced in a way unique to the application. Before calling an ad, set the ad UI according to the [Layout Guide](https://github.com/bidmad/Bidmad-iOS/wiki/Native-Ad-Layout-Setting-Guide-%5BENG%5D). After setting the ad UI, execute the setAdView:adView: method.

*For users of native ad interface updating from v5.3.0 or lower to v6.0.0 or higher, please refer to [NativeAd Migration Guide 6.0.0](https://github.com/bidmad/Bidmad-iOS/wiki/Native-Ad-Migration-to-v6.0.0%5BENG%5D) for your app updates.

<details markdown="1">
<summary>Sample Code (Load & Callbacks)</summary>
<br>

```
// Objective C

@import OpenBiddingHelper; 

@interface NativeAdViewController ()
@property (strong, nonatomic) BidmadNativeAd * ad;
@end
...

- (void)viewDidLoad {
    self.ad = [BidmadNativeAd adWithZoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [self.ad setDelegate:self];
    [self.ad load];
}

#pragma mark Native Ad Delegate Methods

- (void)onClickAd:(BidmadNativeAd *)bidmadAd {
    ADOPLog.printInfo(@"Native Ad Click");
}

- (void)onLoadAd:(BidmadNativeAd *)bidmadAd {
    ADOPLog.printInfo(@"Native Ad Load);
    
    UIView *loadedView = [NSBundle.mainBundle loadNibNamed:@"NativeAdView" owner:nil options:nil].firstObject;
    BIDMADNativeAdView *adView = [BidmadNativeAd findAdViewFromSuperview:loadedView];
    
    [self.view addSubview:loadedView];
    [bidmadAd setRootViewController:self adView:adView];
}

- (void)onLoadFailAd:(BidmadNativeAd *)bidmadAd error:(NSError *)error {
    ADOPLog.printInfo(@"Native Ad Fail: %@", error.localizedDescription);
}

// Swift

let ad: BidmadNativeAd! = BidmadNativeAd(zoneID: "Native Ad Zone ID")

override func viewDidLoad() {
    super.viewDidLoad()

    self.ad.delegate = self
    self.ad.load()
}

// MARK: BIDMADNativeAdDelegate

func onLoad(_ bidmadAd: BidmadNativeAd) {
    if let loadedView = Bundle.main.loadNibNamed("NativeAd", owner: nil)?.first as? UIView,
       let adView = BidmadNativeAd.findView(fromSuperview: loadedView) {
        view.addSubview(loadedView)
        self.ad.setRootViewController(self, adView: adView)
    }
}

func onClick(_ bidmadAd: BidmadNativeAd) {
    print("Native Ad Click")
}

func onLoadFail(_ bidmadAd: BidmadNativeAd, error: Error) {
    print("Native Ad Fail")
}
```
</details>

### Google Ad Network Test Device Setting
</details>
<details markdown="1">
<summary>Details</summary>
<br>

For setting the test device for Google Ad Networks, the following procedure is needed.
First, request an ad to Google, and you will be seeing the log on your console.

```
<Google> To get test ads on this device, set: GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" ];
```
Copy the test device ID on console and set it to the following code.
```
// ObjC
[BidmadCommon setTestDeviceId:@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"];

// Swift
BidmadCommon.setTestDeviceId("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
```

</details>

### References

</details>
<details markdown="1">
<summary>List</summary>
<br>

- [Class Reference for BidmadSDK-iOS](https://github.com/bidmad/Bidmad-iOS/wiki/README-ClassReference)
- Apple privacy survey ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/Apple-privacy-survey%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/Apple-privacy-survey%5BKOR%5D))
- iOS GDPR Guide ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/iOS-GDPR-Guide-%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/iOS-GDPR-Guide-%5BKOR%5D))
- Preparing for iOS 14 ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BKOR%5D))
</details>

