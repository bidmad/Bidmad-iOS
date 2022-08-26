# BidmadSDK iOS
## Integrated App Monetization Solution for Mobile Apps by all Publishers

- Introduction
    - BidmadSDK offers Banner · Interstitial · Reward Video · Offerwall ad types. This document provides an instruction on integrating BidmadSDK into your app.
    - Currently the following list of ad networks are integrated into our SDK.
        <details markdown="1">
        <summary>Ad Network Lists</summary>
        <br>
        
        - Google Manager (Banner, Interstitial, Reward Video)
        - Google Admob (Banner, Interstitial, Reward Video, Rewarded Interstitial, App Open)
        - Pangle (Banner, Interstitial, Reward Video)
        - AppLovin (Banner, Interstitial, Reward Video)
        - UnityAds (Banner, Interstitial, Reward Video)
        - AdColony (Banner, Interstitial, Reward Video)
        - IronSource (Banner, Interstitial, Reward Video)
        - Vungle (Banner, Interstitial, Reward Video)
        - InMobi (Banner, Interstitial, Reward Video)
        - Fyber (Banner, Interstitial, Reward Video)
        - ADOPAtom (Interstitial, Reward Video)
        - AdFit (Banner)
        - Tapjoy (Offerwall)
        </details>
        
## BidmadSDK Installation Guide

1. Development Environment
    - Xcode 13.4.1 (Minimum-Required Xcode Version 13.0)
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. SDK Installation Methods<br>
    1. Add the following code in your project Podfile. (For Xcode 13 or higher)

        ```
        platform :ios, "11.0"

        target "Runner" do
          use_frameworks!
          pod 'BidmadSDK', '4.5.0.0'
          pod 'OpenBiddingHelper', '4.5.0.0'
          pod 'BidmadAdapterFC', '4.5.0.0'
          pod 'BidmadAdapterFNC', '4.5.0.0'
        ```

    2. Followed by entering the following command in Terminal.

        ```
        pod install
        ```

3. Build Settings ( Target → Build Settings )<br>
    - Set Enable Bitcode to No<br>
        ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>
4. info.plist Setting

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
    
5. iOS 14-Related Setups
    - Ever since the update to iOS 14, App Tracking Transparency and SKAdNetwork settings in info.plist became a necessity. Please refere to the following guide for further setup process for iOS 14.
    - [Preparing for iOS 14](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BENG%5D)

## BidmadSDK Interface Guide

### Calling InitializeSDK Method
At the starting point of your app, please call initializeSdk() method. <br>
Without initializeSdk method called, SDK will initialize itself when loading the first ad, subsequently resulting in delay. <br>

<details markdown="1">
<summary>ObjC</summary>
<br>
 
```
[BidmadCommon initializeSdk];
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
BidmadCommon.initializeSdk()
```
</details>

For interstitial and rewarded ads (including rewardInterstitial ads), <br>
at the starting point of your app, load the ad, instead of calling initializeSdk(). <br>
Refer to the guides below for loading the interstitial or rewarded ads and show the ad at the point of your choice.

### Auto Reload feature
For Interstitial / Reward / rewardInterstitial Ads, another ad is automatically reloaded when an ad is shown to the user.
This auto-reload feature can freely be turned on and off with the following interface. Please be noted that the default setting for isAutoReload is true (or YES).

<details markdown="1">
<summary>ObjC</summary>
<br>
 
```
[fullscreenAd setIsAutoReload: YES]; // Auto Reload feature turned on
[fullscreenAd setIsAutoReload: NO]; // Auto Reload feature turned off
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
fullscreenAd.isAutoReload = true // Auto Reload feature turned on
fullscreenAd.isAutoReload = false // Auto Reload feature turned off
```
</details>

### Banner Ad Load

<details markdown="1">
<summary>ObjC</summary>
<br>

```
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
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
import OpenBiddingHelper

class BannerController: UIViewController, BIDMADOpenBiddingBannerDelegate {
  var banner: BidmadBannerAd
  var bannerContainer: UIView

  override func viewDidLoad() {
  
    let zoneID = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    let banner = BidmadBannerAd(with: self, containerView: bannerContainer, zoneID: zoneID)
    banner.delegate = self
    banner.setRefreshInterval(60)
    
    banner.load()
  }
}
```
</details>

### Banner Callback Implementations

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADOpenBiddingBannerLoad:(OpenBiddingBanner *)core {
    NSLog(@"Load");
}

- (void)BIDMADOpenBiddingBannerClick:(OpenBiddingBanner *)core {
    NSLog(@"Click");
}

- (void)BIDMADOpenBiddingBannerAllFail:(OpenBiddingBanner *)core {
    NSLog(@"All Fail");
}

- (void)BIDMADOpenBiddingBannerClosed:(OpenBiddingBanner *)core {
    NSLog(@"Closed");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
public func bidmadOpenBiddingBannerLoad(_ core: OpenBiddingBanner!) {
    print("Load")
}

public func bidmadOpenBiddingBannerClick(_ core: OpenBiddingBanner!) {
    print("Click")
}

public func bidmadOpenBiddingBannerClosed(_ core: OpenBiddingBanner!) {
    print("Closed")
}

public func bidmadOpenBiddingBannerAllFail(_ core: OpenBiddingBanner!) {
    print("AllFail")
}
```
</details>

### Interstitial Ad Load

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@import OpenBiddingHelper;

@interface InterstitialViewController () <BIDMADOpenBiddingInterstitialDelegate> {
    BidmadInterstitialAd *interstitialAd;
}
@end

@implementation InterstitialViewController
- (void)viewDidLoad {
    
    NSString *zoneID = @"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    interstitialAd = [[BidmadInterstitialAd alloc] initWith:self zoneID:zoneID];
    [interstitialAd setDelegate: self];
        
    // Auto Reload feature can be turned on and off with the following method
    [interstitialAd setIsAutoReload:YES]; // Default is YES (Auto Reload turned ON)
}

-(void)loadAd {
    [interstitialAd load];
   
}
...
-(void)showAd {
    if ([interstitialAd isLoaded])
        [interstitialAd show];
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
import OpenBiddingHelper

class InterstitialController: UIViewController, BIDMADOpenBiddingInterstitialDelegate {
  var interstitialAd: BidmadInterstitialAd
   
  override func viewDidLoad() {
    let zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    interstitialAd = BidmadInterstitialAd(with: self, zoneID: zoneID)
    interstitialAd.delegate = self
    
    // Auto Reload feature can be turned on and off with the following method
    interstitialAd.isAutoReload = true // Default is true (Auto Reload turned ON)
  }
  
  func loadAd() {
      interstitialAd.load()
  }

  func showAd() {
    if interstitialAd.isLoaded() {
        interstitialAd.show()
    }
  }
}
```
</details>

### Interstitial Callback Implementations

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADOpenBiddingInterstitialLoad:(OpenBiddingInterstitial *)core {
    NSLog(@"Load");
}

- (void)BIDMADOpenBiddingInterstitialShow:(OpenBiddingInterstitial *)core {
    NSLog(@"Show");
}

- (void)BIDMADOpenBiddingInterstitialClose:(OpenBiddingInterstitial *)core {
    NSLog(@"Close");
}

- (void)BIDMADOpenBiddingInterstitialAllFail:(OpenBiddingInterstitial *)core {
    NSLog(@"AllFail");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
public func bidmadOpenBiddingInterstitialLoad(_ core: OpenBiddingInterstitial!) {
    print("Load")
}

public func bidmadOpenBiddingInterstitialShow(_ core: OpenBiddingInterstitial!) {
    print("Show")
}

public func bidmadOpenBiddingInterstitialClose(_ core: OpenBiddingInterstitial!) {
    print("Close")
}

public func bidmadOpenBiddingInterstitialAllFail(_ core: OpenBiddingInterstitial!) {
    print("AllFail")
}
```
</details>

### Reward Ad Load

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@import OpenBiddingHelper;

@interface RewardViewController () <BIDMADOpenBiddingRewardVideoDelegate> {
    BidmadRewardAd *rewardAd;
}
@end

@implementation RewardViewController

- (void)viewDidLoad {
    
    NSString *zoneID = @"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    rewardAd = [[BidmadRewardAd alloc] initWith:self zoneID:zoneID];
    rewardAd.delegate = self;
        
    // Auto Reload feature can be turned on and off with the following method
    [rewardAd setIsAutoReload: YES] // Default is YES (Auto Reload turned ON)
}

-(void)loadReward {
    [rewardAd load];
}
   

-(void)showReward {
    if ([rewardAd isLoaded])
        [rewardAd show];
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
import OpenBiddingHelper

class RewardVideoController: UIViewController, BIDMADOpenBiddingRewardVideoDelegate {
  var rewardAd: BidmadRewardAd

  override func viewDidLoad() {
    let zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    rewardAd = BidmadRewardAd(with: self, zoneID: zoneID)
    rewardAd.delegate = self
        
    // Auto Reload feature can be turned on and off with the following method
    rewardAd.isAutoReload = true // Default is true (Auto Reload turned ON)
  }
  
  func loadAd() {
    rewardAd.load()
  }

  func showAd() {
    if rewardAd.isLoaded() {
        rewardAd.show()
    }
  }
  ...
}
```
</details>

### Reward Callback Implementations

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADOpenBiddingRewardSkipped:(OpenBiddingRewardVideo *)core {
    NSLog(@"Skipped");
}

- (void)BIDMADOpenBiddingRewardVideoLoad:(OpenBiddingRewardVideo *)core {
    NSLog(@"Load");
}

- (void)BIDMADOpenBiddingRewardVideoShow:(OpenBiddingRewardVideo *)core {
    NSLog(@"Show");
}

- (void)BIDMADOpenBiddingRewardVideoClick:(OpenBiddingRewardVideo *)core {
    NSLog(@"Click");
}

- (void)BIDMADOpenBiddingRewardVideoClose:(OpenBiddingRewardVideo *)core {
    NSLog(@"Close");
}

- (void)BIDMADOpenBiddingRewardVideoSucceed:(OpenBiddingRewardVideo *)core {
    NSLog(@"Success");
}

- (void)BIDMADOpenBiddingRewardVideoAllFail:(OpenBiddingRewardVideo *)core {
    NSLog(@"All Fail");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
public func bidmadOpenBiddingRewardSkipped(_ core: OpenBiddingRewardVideo!) {
    print("Skipped")
}

public func bidmadOpenBiddingRewardVideoLoad(_ core: OpenBiddingRewardVideo!) {
    print("VideoLoad")
}

public func bidmadOpenBiddingRewardVideoShow(_ core: OpenBiddingRewardVideo!) {
    print("VideoShow")
}

public func bidmadOpenBiddingRewardVideoClick(_ core: OpenBiddingRewardVideo!) {
    print("VideoClick")
}

public func bidmadOpenBiddingRewardVideoClose(_ core: OpenBiddingRewardVideo!) {
    print("VideoClose")
}

public func bidmadOpenBiddingRewardVideoSucceed(_ core: OpenBiddingRewardVideo!) {
    print("VideoSucceed")
}

public func bidmadOpenBiddingRewardVideoAllFail(_ core: OpenBiddingRewardVideo!) {
    print("VideoAllFail")
}
```
</details>

### Reward Interstitial Ad Load

Reward Interstitial is a new reward-type advertising format that can provide rewarded ads when switching between pages in an app.<br>
Unlike Reward ads, users can view Reward Interstitial ads without user's consent. However,  the developer needs to provide a screen announcing that there will be a reward for watching an ad and the user can cancel watching the ad if he/she wants. (Please check the BidmadSDK sample app)<br>
Reward Interstitial Ads only offer skippable ads.<br>

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@import OpenBiddingHelper;

@interface RewardInterstitialViewController : UIViewController<BIDMADRewardInterstitialDelegate>
···
@end

@implementation RewardInterstitialViewController {
    BidmadRewardInterstitialAd *rewardInterstitialAd;
}

- (void)viewDidLoad {
    rewardInterstitialAd = [[BidmadRewardInterstitialAd alloc] initWith:self zoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    rewardInterstitialAd.delegate = self;
    [rewardInterstitialAd load];
        
    // Auto Reload feature can be turned on and off with the following method
    [rewardInterstitialAd setIsAutoReload: YES] // Default is YES (Auto Reload turned ON)
}

- (void)adShow {
    if (rewardInterstitialAd.isLoaded) {
        [rewardInterstitialAd show];
    }
}
···
@
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
import OpenBiddingHelper

class RewardInterstitialViewController: UIViewController, OpenBiddingRewardInterstitialDelegate {
    var rewardInterstititial: BidmadRewardInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        rewardInterstitialAd = BidmadRewardInterstitialAd(with: self, zoneID: zoneID)
        rewardInterstitialAd.delegate = self
        rewardInterstitialAd.load()
        
        // Auto Reload feature can be turned on and off with the following method
        rewardInterstitialAd.isAutoReload = true // Default is true (Auto Reload turned ON)
    }
    
    func adShow() {
        if rewardInterstitialAd.isLoaded() {
            rewardInterstitialAd.show()
        }
    }
}
```
</details>

### Reward Interstitial Ad Callback Implementation<br>

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)OpenBiddingRewardInterstitialLoad:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Load");
}

- (void)OpenBiddingRewardInterstitialShow:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Show");
}

- (void)OpenBiddingRewardInterstitialClick:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Click");
}

- (void)OpenBiddingRewardInterstitialClose:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Close");
}

- (void)OpenBiddingRewardInterstitialSkipped:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Skipped");
}

- (void)OpenBiddingRewardInterstitialSuccess:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Success");
}

- (void)OpenBiddingRewardInterstitialAllFail:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"All Fail");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
public func openBiddingRewardInterstitialLoad(_ core: OpenBiddingRewardInterstitial!) {
    print("Load")
}

public func openBiddingRewardInterstitialShow(_ core: OpenBiddingRewardInterstitial!) {
    print("Show")
}

public func openBiddingRewardInterstitialClick(_ core: OpenBiddingRewardInterstitial!) {
    print("Click")
}

public func openBiddingRewardInterstitialClose(_ core: OpenBiddingRewardInterstitial!) {
    print("Close")
}

public func openBiddingRewardInterstitialSkipped(_ core: OpenBiddingRewardInterstitial!) {
    print("Skipped")
}

public func openBiddingRewardInterstitialSuccess(_ core: OpenBiddingRewardInterstitial!) {
    print("Success")
}

public func openBiddingRewardInterstitialAllFail(_ core: OpenBiddingRewardInterstitial!) {
    print("AllFail")
}
```

</details>

### Loading an App Open Ad
App Open ads are shown to users when the app is brought to the foreground, monetizing the app loading screen.<br>
App Open Ads show app-branding on the top of the ad view so that the app users can be notified that they are using your app.<br>
BidmadSDK provides registerForAppOpenAdForZoneID method for easier App Open ad load.<br>
The registerForAppOpenAdForZoneID method reloads ads when the user closes the App Open Ad.<br>

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@import OpenBiddingHelper;

@interface AppDelegate () <OpenBiddingAppOpenAdDelegate>
···
@end

@implementation AppDelegate {
    BidmadAppOpenAd *appOpenAd;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self->appOpenAd = [[BidmadAppOpenAd alloc] initWith:self.window.rootViewController zoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [self->appOpenAd setDelegate: self];
    
    return YES;
}

- (void)cancelAppOpenAd {
    // If you no longer wish to load App Open ads, please deregister by calling the following method.
    if (self->appOpenAd != nil) {
        [self->appOpenAd deregisterForAppOpenAd];
    }
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
import OpenBiddingHelper

class AppDelegate: UIResponder, UIApplicationDelegate, OpenBiddingAppOpenAdDelegate {
    var window: UIWindow?
    var appOpenAd: BidmadAppOpenAd!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appOpenAd = BidmadAppOpenAd(with: self.window.rootViewController, zoneID: zoneID)
        appOpenAd.delegate = self
        
        return true
    }
    
    func cancelAppOpenAd {
        // If you no longer wish to load App Open ads, please deregister by calling the following method.
        appOpenAd.deregisterForAppOpenAd()
    }
}
```
</details>

Alternatively, you can load App Open ads manually as the code written below.<br>
Please call the requestAppOpenAd method again after receiving the BIDMADAppOpenAdClose callback as the ad does not load again after the user closes the ad.

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@import OpenBiddingHelper;

@interface AppDelegate () <OpenBiddingAppOpenAdDelegate>
···
@end

@implementation AppDelegate {
    BidmadAppOpenAd *appOpenAd;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Because init method automatically registers ad display, 
    // if you wish to load the ad manually, you MUST call deregisterForAppOpenAd method.
    self->appOpenAd = [[BidmadAppOpenAd alloc] initWith:self.window.rootViewController zoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [self->appOpenAd deregisterForAppOpenAd];
    [self->appOpenAd setDelegate: self];
    
    [self->appOpenAd load];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([self->appOpenAd isLoaded])
        [self->appOpenAd show];
}

// App Open Show callback, Re-Load the Ad for later use
- (void)OpenBiddingAppOpenAdShow:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Show");
    [self->appOpenAd load];
}

```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
import OpenBiddingHelper

class AppDelegate: UIResponder, UIApplicationDelegate, OpenBiddingAppOpenAdDelegate {
    var window: UIWindow?
    var appOpenAd: BIDMADAppOpenAd!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        // Because init method automatically registers ad display, 
        // if you wish to load the ad manually, you MUST call deregisterForAppOpenAd method.
        let zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        appOpenAd = BidmadAppOpenAd(with: self.window.rootViewController, zoneID: zoneID)
        appOpenAd.deregisterForAppOpenAd()
        appOpenAd.delegate = self
        appOpenAd.load()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if appOpenAd.isLoaded() {
            appOpenAd.show()
        }
    }
    
    // App Open Close callback, Re-Load the Ad for later use
    public func openBiddingAppOpenAdShow(_ core: OpenBiddingAppOpenAd!) {
        offerwallAd.load()
    }
}
```
</details>

### AppOpen Ad Callback Implementation

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)OpenBiddingAppOpenAdLoad:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Load");
}

- (void)OpenBiddingAppOpenAdShow:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Show");
}

- (void)OpenBiddingAppOpenAdClick:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Click");
}

- (void)OpenBiddingAppOpenAdClose:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Close");
}

- (void)OpenBiddingAppOpenAdAllFail:(OpenBiddingAppOpenAd *)core code:(NSString *)error {
    NSLog(@"All Fail");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
public func openBiddingAppOpenAdLoad(_ core: OpenBiddingAppOpenAd!) {
    print("Load")
}

public func openBiddingAppOpenAdShow(_ core: OpenBiddingAppOpenAd!) {
    print("Show")
}

public func openBiddingAppOpenAdClick(_ core: OpenBiddingAppOpenAd!) {
    print("Click")
}

public func openBiddingAppOpenAdClose(_ core: OpenBiddingAppOpenAd!) {
    print("Close")
}

public func openBiddingAppOpenAdAllFail(_ core: OpenBiddingAppOpenAd!, code error: String!) {
    print("AllFail")
}
```
</details>

### Offerwall Ad Load and Currency Load

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@import OpenBiddingHelper;

@interface OfferwallController : UIViewController<BIDMADOfferwallDelegate> {
    BidmadOfferwallAd *offerwallAd;
}
@end

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"AppUI isSDKInit %d", [BIDMADOfferwall isSDKInit]);
    
    self->offerwallAd = [[BidmadOfferwallAd alloc] initWith:self zoneID:@"fb5d83af-9ef3-443e-8d8f-b97f63066683"];
    [self->offerwallAd setDelegate: self];
}

-(void)loadOfferwall {
    [self->offerwallAd load];
}

-(void)showOfferwall {
    if ([self->offerwallAd isLoaded])
        [self->offerwallAd show];
}

-(void)getCurrency {
    [self->offerwallAd getCurrencyWithCurrencyReceivalCompletion:^(BOOL isSuccess, NSInteger currencyAmount) {
        if (!isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Currency Receival Failed");
                [self.offerwallCallbackDisplay setText:@"Currency Receival Failed"];
            });
            return;
        }
        
        NSLog(@"Currency Receival Success");
        [self.offerwallCallbackDisplay setText:@"Currency Receival Success"];
        [self.textCurrency setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:currencyAmount]]];
    }];
}

-(void)spendCurrency:(int)amount {
    [self->offerwallAd spendCurrency:[[NSNumber numberWithInt:amount] integerValue] currencySpenditureCompletion:^(BOOL isSuccess, NSInteger currencyAmount) {
        if (!isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Currency Spenditure Failed");
                [self.offerwallCallbackDisplay setText:@"Currency Spenditure Failed"];
            });
        }
        
        NSLog(@"Currency Spenditure Success");
        [self.offerwallCallbackDisplay setText:@"Currency Spenditure Success"];
        [self.textCurrency setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:currencyAmount]]];
    }];
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
import OpenBiddingHelper

class OfferwallController: UIViewController, BIDMADOfferwallDelegate {
    var offerwallAd: BidmadOfferwallAd

    override func viewDidLoad() {
        let zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        offerwallAd = BidmadOfferwallAd(with: self, zoneID: zoneID)
        offerwallAd.delegate = self
        offerwallAd.load()
    }

    func showAd() {
        if offerwallAd.isLoaded() {
            offerwallAd.show()
        }
    }

    func getCurrency() {
        offerwallAd.getCurrency { isSuccess, currencyAmount in
            if isSuccess {
                self.userCurrencyAmount = currencyAmount
            }
        }
    }

    func spendCurrency(amount: Int) {
        let spenditure = 3
        offerwallAd.spendCurrency(spenditure) { isSuccess, currencyAmount in
            if isSuccess {
                self.userCurrencyAmount = currencyAmount
            }
        }
    }
}
```
</details>

### Offerwall Callback Implementations

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADOfferwallLoadAd:(BIDMADOfferwall *)core {
    NSLog(@"Load");
}

- (void)BIDMADOfferwallShowAd:(BIDMADOfferwall *)core {
    NSLog(@"Show");
}

- (void)BIDMADOfferwallCloseAd:(BIDMADOfferwall *)core {
    NSLog(@"Close");
}

- (void)BIDMADOfferwallFailedAd:(BIDMADOfferwall *)core {
    NSLog(@"Failed");
}

- (void)BIDMADOfferwallInitSuccess:(BIDMADOfferwall *)core {
    NSLog(@"Init Success");
}

- (void)BIDMADOfferwallInitFail:(BIDMADOfferwall *)core error:(NSString *)error {
    NSLog(@"Init Failed");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
public func bidmadOfferwallLoadAd(_ core: BIDMADOfferwall!) {
    print("Load")
}

public func bidmadOfferwallShowAd(_ core: BIDMADOfferwall!) {
    print("Show")
}

public func bidmadOfferwallCloseAd(_ core: BIDMADOfferwall!) {
    print("Close")
}

public func bidmadOfferwallFailedAd(_ core: BIDMADOfferwall!) {
    print("Failed")
}

public func bidmadOfferwallInitSuccess(_ core: BIDMADOfferwall!) {
    print("InitSuccess")
}

public func bidmadOfferwallInitFail(_ core: BIDMADOfferwall!, error: String!) {
    print("InitFail")
}
```
</details>

### Native Ad Load and Callback Implementation
Native Ad allows advertisement designed and produced in a unique format that fits the application.<br>
Before requesting the native ad, please set the native ad UI by following the guide from [Layout Guide](https://github.com/bidmad/Bidmad-iOS/wiki/Native-Ad-Layout-Setting-Guide-%5BENG%5D).<br>
After setting the UI for the ad, please load BIDMADNativeAd which contains ad data.<br> 
And, call BIDMADNativeAdLoader.setup(for:BIDMADNativeAd, viewController:UIViewController, adView:BIDMADNativeAdView) method. <br>
After calling the method, set each data from BIDMADNativeAd Instance into your UI appropriately. <br>

<details markdown="1">
<summary>ObjC</summary>
<br>

@import OpenBiddingHelper;

```
- (void)viewDidLoad {
    [super viewDidLoad];

    // Request to load ad data (BIDMADNativeAd) from BidmadSDK 
    BIDMADNativeAdLoader* adLoader = [[BIDMADNativeAdLoader alloc] init];
    adLoader.delegate = self;
    // Insert your own zoneID as an argument in the method, 'requestFor:(NSString *)'
    [adLoader requestFor:@"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"];
}

#pragma mark Native Ad Delegate Methods

// LOAD CALLBACK: Show your ad from the loaded ad from the load callback.
- (void)bidmadNativeAdWithLoadedAd:(BIDMADNativeAd *)loadedAd {

    // Setting up a click callback for each ad you load
    [loadedAd setClickCallback:^(BIDMADNativeAd * clickedAd) {
        NSLog(@"Native Ad %@ is clicked.", clickedAd.description);
    }];

    // Instantiating Ad View from XIB file. Please refer to the layout guide for creating XIB file.
    BIDMADNativeAdView *adView = [[[UINib nibWithNibName:@"NativeAd" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    
    // Registering your ad view and loaded ad before showing the ad 
    [BidmadNativeAdLoader setupFor:loadedAd viewController:self adView:adView];
    
    // Showing ad with advertisement data from loaded ad.
    if (loadedAd.headline != nil) {
        [adView.headlineViewCustom setText:loadedAd.headline];
    } else {
        [adView.headlineViewCustom setHidden:YES];
    }
    
    if (loadedAd.body != nil) {
        [adView.bodyViewCustom setText:loadedAd.body];
    } else {
        [adView.bodyViewCustom setHidden:YES];
    }
    
    if (loadedAd.callToAction != nil) {
        [adView.callToActionViewCustom setTitle:loadedAd.callToAction forState:UIControlStateNormal];
    } else {
        [adView.callToActionViewCustom setHidden:YES];
    }
    
    if (loadedAd.icon != nil) {
        [adView.iconViewCustom setImage:loadedAd.icon];
    } else {
        [adView.iconViewCustom setHidden:YES];
    }
    
    if (loadedAd.starRating != nil) {
        [adView.starRatingViewCustom performSelector:@selector(setText:) withObject:[NSString stringWithFormat:@"%@ ⭐️", loadedAd.starRating]];
    } else {
        [adView.starRatingViewCustom setHidden:YES];
    }
    
    if (loadedAd.store != nil) {
        [adView.storeViewCustom setText:loadedAd.store];
    } else {
        [adView.storeViewCustom setHidden:YES];
    }
    
    if (loadedAd.price != nil) {
        [adView.priceViewCustom setText:loadedAd.price];
    } else {
        [adView.priceViewCustom setHidden:YES];
    }
    
    if (loadedAd.advertiser != nil) {
        [adView.advertiserViewCustom setText:loadedAd.advertiser];
    } else {
        [adView.advertiserViewCustom setHidden:YES];
    }
}

- (void)bidmadNativeAdAllFail:(NSError *)error {
    NSLog(@"Native Ad Mediation all failed.");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Request to load ad data (BIDMADNativeAd) from BidmadSDK 
    let adLoader = BIDMADNativeAdLoader()
    adLoader.delegate = self
    // Insert your own zoneID as an argument in the method, 'requestFor:(NSString *)'
    adLoader.request(for: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
}

// MARK: Native Ad Delegate Methods

// LOAD CALLBACK: Show your ad from the loaded ad from the load callback.
func bidmadNativeAd(withLoadedAd loadedAd: BIDMADNativeAd) {
    
    // Setting up a click callback for each ad you load
    loadedAd.setClickCallback { clickedAd in
        print("Native Ad \(clickedAd) is clicked.")
    }

    // Instantiating Ad View from XIB file. Please refer to the layout guide for creating XIB file.
    let adView =
    UINib(nibName: "NativeAd", bundle: nil).instantiate(withOwner: nil, options: nil).first as! BIDMADNativeAdView
    
    // Registering your ad view and loaded ad before showing the ad
    BidmadNativeAdLoader.setup(for: loadedAd, viewController: self, adView: adView)
    
    // Showing ad with advertisement data from loaded ad.
    if loadedAd.headline != nil {
        adView.headlineViewCustom?.text = loadedAd.headline
    } else {
        adView.headlineViewCustom?.isHidden = true
    }
    
    if (loadedAd.body != nil) {
        adView.bodyViewCustom?.text = loadedAd.body
    } else {
        adView.bodyViewCustom?.isHidden = true
    }
    
    if (loadedAd.callToAction != nil) {
        adView.callToActionViewCustom?.setTitle(loadedAd.callToAction, for: .normal)
    } else {
        adView.callToActionViewCustom?.isHidden = true
    }
    
    if (loadedAd.icon != nil) {
        adView.iconViewCustom?.image = loadedAd.icon
    } else {
        adView.iconViewCustom?.isHidden = true
    }
    
    if (loadedAd.starRating != nil) {
        (adView.starRatingViewCustom as! UILabel).text = "⭐️ \(loadedAd.starRating!)"
    } else {
        adView.starRatingViewCustom?.isHidden = true
    }
    
    if (loadedAd.store != nil) {
        adView.storeViewCustom?.text = loadedAd.store
    } else {
        adView.storeViewCustom?.isHidden = true
    }
    
    if (loadedAd.price != nil) {
        adView.priceViewCustom?.text = loadedAd.price
    } else {
        adView.priceViewCustom?.isHidden = true
    }
    
    if (loadedAd.advertiser != nil) {
        adView.advertiserViewCustom?.text = loadedAd.advertiser
    } else {
        adView.advertiserViewCustom?.isHidden = true
    }
}

func bidmadNativeAdAllFail(_ error: NSError) {
    print("Native Ad Mediation All Failed")
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
