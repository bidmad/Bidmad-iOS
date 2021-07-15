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
        - AppLovin (Reward Video)
        - UnityAds (Reward Video, Banner)
        - Facebook Audience Network (Banner, Interstitial, Reward Video)
        - ADOPAtom (Interstitial, Reward Video)
        - Tapjoy (Offerwall)
        </details>
        
## BidmadSDK Installation Guide

1. Development Environment
    - Xcode 12.0
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. SDK Installation Methods
    - **(Highly Recommended)** Installation through CocoaPods

        Add the following code in your project Podfile.

        ```
        platform :ios, "11.0"

        target "Runner" do
         use_frameworks!
         pod "BidmadSDK", "2.8.0"
        ```

        Followed by entering the following command in Terminal.

        ```
        pod install
        ```

    - **(Not Recommeded)** Manual Framework Embedding Method **( Manual Framework Embedding Method does not support Swift )**
        1. Add libraries to "Link Binary With Libraries" settings as shown in the image below ( Target → Build Phases → Link Binary With Libraries )<br>
            ![Link_Binary_With_Libraries](https://i.imgur.com/73OTB5n.png) <br>
        2. Add frameworks and bundles to projects as below ( Target → General → Frameworks, Libraries, and Embedded Content )<br>
            ![Frameworks_Libraries_and_Embedded_Content](https://i.imgur.com/rWvmsaN.png)
        3. Add Bundle Resources as shown in the following image to "Copy Bundle Resources" ( Target → Build Phases → Copy Bundle Resources )<br>
            ![Copy_Bundle_Resources](https://i.imgur.com/hoGfVJB.png)<br>
    3. Build Settings ( Target → Build Settings )
    1. Build Setting for CocoaPods Users<br>
        - Set Enable Bitcode to No<br>
            ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>
    2. Build Settings for Manual Framework Embedding Method Users<br>
        - Set Enable Bitcode to No<br>
            ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>
        - Add -ObjC Flag to Other Linker Flag<br>
            ![Other_Linker](https://i.imgur.com/feieEZX.png)<br>
        - Set Allow Non-Modular Includes In Framework Modules to Yes<br>
            ![Allow_Non_Modular_Includes_In_Framework_Modules](https://i.imgur.com/ap4RddO.png)
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

### Banner Ad Load

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@interface BannerViewController : UIViewController<BIDMADBannerDelegate>
...
@end
@implementation BannerViewController

- (void)viewDidLoad {
    ...
    // Please set the "bannerSize" to "banner_320_50" only.
    banner = [[BIDMADBanner alloc] initWithParentViewController:self rootView:self.BannerContainer bannerSize:banner_320_50];
    [banner setZoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [banner setDelegate:self];
    [banner setRefreshInterval:60];
    ...
    [banner requestBannerView]; // Request to load and view the banner
}
...
- (void)removeAds {
    [banner removeAds] // Remove Banner from UIView
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
class BannerController: UIViewController, BIDMADBannerDelegate {
  var banner: BIDMADBanner

  override func viewDidLoad() {
    ...
    // "bannerSize"는 "banner_320_50" 고정값만 전달해주십시오
    let banner = BIDMADBanner(parentViewController: self, rootView: bannerContainer, bannerSize: banner_320_50)!
    banner.zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    banner.refreshInterval = 60
    banner.delegate = self
    ...
    banner.requestView() // Request to load and view the banner
  }

  func removeBanner() {
    banner.removeAds() // Remove Banner from UIView
  }
  ...
}
```
</details>

### Banner Callback Implementations

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADBannerLoad:(BIDMADBanner *)core {
    NSLog(@"BIDMADBannerLoad");
}

- (void)BIDMADBannerClosed:(BIDMADBanner *)core {
    NSLog(@"BIDMADBannerClosed");
}

- (void)BIDMADBannerAllFail:(BIDMADBanner *)core {
    NSLog(@"BIDMADBannerAllFail");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
func bidmadBannerLoad(_ core: BIDMADBanner!) {
    print("bidmadBannerLoad");
}

func bidmadBannerClosed(_ core: BIDMADBanner!) {
    print("bidmadBannerClosed");
}

func bidmadBannerAllFail(_ core: BIDMADBanner!) {
    print("bidmadBannerAllFail");
}
```
</details>

### Interstitial Ad Load

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@interface InterstitialViewController : UIViewController<BIDMADInterstitialDelegate>
...
@end
...
@implementation InterstitialViewController
- (void)viewDidLoad {
    ...
    interstitial = [[BIDMADInterstitial alloc] init];
    [interstitial setParentViewController:self];
    [interstitial setZoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [interstitial setDelegate:self];
}
...
-(void)loadAd {
    [interstitial loadInterstitialView];
   
}
...
-(void)showAd {
    if([interstitial isLoaded]){
        [interstitial showInterstitialView];
    }
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

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
</details>

### Interstitial Callback Implementations

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADInterstitialClose:(BIDMADInterstitial *)core {
    NSLog(@"BIDMADInterstitialClose");
}

- (void)BIDMADInterstitialShow:(BIDMADInterstitial *)core {
    NSLog(@"BIDMADInterstitialShow");
}

- (void)BIDMADInterstitialLoad:(BIDMADInterstitial *)core {
    NSLog(@"BIDMADInterstitialLoad");
}
- (void)BIDMADInterstitialAllFail:(BIDMADInterstitial *)core {
    NSLog(@"BIDMADInterstitialAllFail");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
func bidmadInterstitialClose(_ core: BIDMADInterstitial!) {
    print("bidmadInterstitialClose");
}

func bidmadInterstitialShow(_ core: BIDMADInterstitial!) {
    print("bidmadInterstitialShow");
}

func bidmadInterstitialLoad(_ core: BIDMADInterstitial!) {
    print("bidmadInterstitialLoad");
}

func bidmadInterstitialAllFail(_ core: BIDMADInterstitial!) {
    print("bidmadInterstitialAllFail");
}
```
</details>

### Reward Ad Load

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@interface RewardViewController : UIViewController<BIDMADRewardVideoDelegate>
...
@end
...
@implementation RewardViewController

- (void)viewDidLoad {
    ...
    rewardVideo = [[BIDMADRewardVideo alloc]init];
    [rewardVideo setZoneID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [rewardVideo setParentViewController:self];
    [rewardVideo setDelegate:self];
}
...
-(void)loadReward {
    [reward loadRewardVideo];
}
   
...
-(void)showReward {
    if([reward isLoaded]){
        [reward showRewardVideo];
    }
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

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
</details>

### Reward Callback Implementations

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADRewardVideoLoad:(BIDMADRewardVideo *)core {
    NSLog(@"BIDMADRewardVideoLoad");
}

- (void)BIDMADRewardVideoAllFail:(BIDMADRewardVideo *)core {
    NSLog(@"BIDMADRewardVideoAllFail");
}

- (void)BIDMADRewardVideoShow:(BIDMADRewardVideo *)core {
    NSLog(@"BIDMADRewardVideoShow");
}

- (void)BIDMADRewardVideoClose:(BIDMADRewardVideo *)core {
    NSLog(@"BIDMADRewardVideoClose");
}

- (void)BIDMADRewardVideoSucceed:(BIDMADRewardVideo *)core {
    NSLog(@"BIDMADRewardVideoSucceed");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
func bidmadRewardVideoLoad(_ core: BIDMADRewardVideo!) {
    NSLog(@"bidmadRewardVideoLoad");
}

func bidmadRewardVideoAllFail(_ core: BIDMADRewardVideo!) {
    NSLog(@"bidmadRewardVideoAllFail");
}

func bidmadRewardVideoShow(_ core: BIDMADRewardVideo!) {
    NSLog(@"bidmadRewardVideoShow");
}

func bidmadRewardVideoClose(_ core: BIDMADRewardVideo!) {
    NSLog(@"bidmadRewardVideoClose");
}

func bidmadRewardVideoSucceed(_ core: BIDMADRewardVideo!) {
    NSLog(@"bidmadRewardVideoSucceed");
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
#import <BidmadSdk/BIDMADRewardInterstitial.h>

@interface RewardInterstitialViewController : UIViewController<BIDMADRewardInterstitialDelegate>
···
@end

@implementation RewardInterstitialViewController {
    BIDMADRewardInterstitial *rewardInterstitial;
}

- (void)viewDidLoad {
    rewardInterstitial = [[BIDMADRewardInterstitial alloc] init];
    rewardInterstitial.zoneID = @"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    rewardInterstitial.parentViewController = self;
    rewardInterstitial.delegate = self;
    [rewardInterstitial requestRewardInterstitial];
}

- (void)adShow {
    if (rewardInterstitial.isLoaded) {
        [rewardInterstitial showRewardInterstitialView];
    }
}

- (void)removeAd {
    [rewardInterstitial removeRewardInterstitialAds];
    rewardInterstitial = nil;
}
···
@
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
import BidmadSDK

class RewardInterstitialViewControllerSwift: UIViewController {
    var rewardInterstititial: BIDMADRewardInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rewardInterstititial = BIDMADRewardInterstitial()
        rewardInterstititial.zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        rewardInterstititial.parentViewController = self
        rewardInterstititial.delegate = self
        rewardInterstititial.request()
    }
    
    func adShow() {
        if (rewardInterstititial.isLoaded) {
            rewardInterstititial.showView()
        }
    }
    
    func removeAd() {
        rewardInterstititial.removeAds()
        rewardInterstititial = nil
    }
}
```
</details>

### Reward Interstitial Ad Callback Implementation<br>

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADRewardInterstitialLoad:(BIDMADRewardInterstitial *)core {
    NSLog(@"BIDMADRewardInterstitialLoad");
}
- (void)BIDMADRewardInterstitialShow:(BIDMADRewardInterstitial *)core {
    NSLog(@"BIDMADRewardInterstitialShow");
}
- (void)BIDMADRewardInterstitialClose:(BIDMADRewardInterstitial *)core {
    NSLog(@"BIDMADRewardInterstitialClose");
}
- (void)BIDMADRewardInterstitialSkipped:(BIDMADRewardInterstitial *)core {
    NSLog(@"BIDMADRewardInterstitialSkipped");
}
- (void)BIDMADRewardInterstitialSuccess:(BIDMADRewardInterstitial *)core {
    NSLog(@"BIDMADRewardInterstitialSuccess");
}
- (void)BIDMADRewardInterstitialAllFail:(BIDMADRewardInterstitial *)core {
    NSLog(@"BIDMADRewardInterstitialAllFail");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
extension RewardInterstitialViewControllerSwift: BIDMADRewardInterstitialDelegate {
    func bidmadRewardInterstitialLoad(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialLoad")
    }
    func bidmadRewardInterstitialShow(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialShow")
    }
    func bidmadRewardInterstitialClose(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialClose")
    }
    func bidmadRewardInterstitialSkipped(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialSkipped")
    }
    func bidmadRewardInterstitialSuccess(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialSuccess")
    }
    func bidmadRewardInterstitialAllFail(_ core: BIDMADRewardInterstitial!) {
        print("bidmadRewardInterstitialAllFail")
    }
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
@interface AppDelegate () <BIDMADAppOpenAdDelegate>
···
@end

@implementation AppDelegate {
    BIDMADAppOpenAd *bidmadAppOpenAd;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    bidmadAppOpenAd = [[BIDMADAppOpenAd alloc] init];
    [bidmadAppOpenAd setDelegate: self];
    [bidmadAppOpenAd registerForAppOpenAdForZoneID: @"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    
    return YES;
}

- (void)cancelAppOpenAd {
    // If you no longer wish to load App Open ads, please deregister by calling the following method.
    [bidmadAppOpenAd deregisterForAppOpenAd];
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appOpen: BIDMADAppOpenAd!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appOpen = BIDMADAppOpenAd()
        appOpen.delegate = self
        appOpen.registerForAppOpenAd(forZoneID: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
        
        return true
    }
    
    func cancelAppOpenAd {
        // If you no longer wish to load App Open ads, please deregister by calling the following method.
        appOpen.deregisterForAppOpenAd()
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
@interface AppDelegate () <BIDMADAppOpenAdDelegate>
···
@end

@implementation AppDelegate {
    BIDMADAppOpenAd *bidmadAppOpenAd;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    bidmadAppOpenAd = [[BIDMADAppOpenAd alloc] init];
    bidmadAppOpenAd.zoneID = @"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    bidmadAppOpenAd.delegate = self;
    [bidmadAppOpenAd requestAppOpenAd];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (bidmadAppOpenAd.isLoaded) {
        [self.bidmadAppOpenAd showAppOpenAd];
    }
}

// App Open Close callback, Re-Load the Ad for later use
- (void)BIDMADAppOpenAdClose:(BIDMADAppOpenAd *)core {
    NSLog(@"Callback → BIDMADAppOpenAdClose");
    [bidmadAppOpenAd requestAppOpenAd];
}

```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appOpen: BIDMADAppOpenAd!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appOpen = BIDMADAppOpenAd()
        appOpen.zoneID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        appOpen.delegate = self;
        appOpen.request()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if (appOpen.isLoaded) {
            self.appOpen.show()
        }
    }
    
    // App Open Close callback, Re-Load the Ad for later use
    func bidmadAppOpenAdClose(_ core: BIDMADAppOpenAd!) {
        print("bidmadAppOpenAdClose")
        appOpen.request()
    }
}
```
</details>

### AppOpen Ad Callback Implementation

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADAppOpenAdAllFail:(BIDMADAppOpenAd *)core code:(NSString *)error {
    NSLog(@"BidmadSDK App Open Ad Callback → AllFail");
}

- (void)BIDMADAppOpenAdLoad:(BIDMADAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Load");
}

- (void)BIDMADAppOpenAdShow:(BIDMADAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Show");
}

- (void)BIDMADAppOpenAdClose:(BIDMADAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Close");
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
extension AppDelegate: BIDMADAppOpenAdDelegate {
    func bidmadAppOpenAdLoad(_ core: BIDMADAppOpenAd!) {
        print("bidmadAppOpenAdLoad")
    }
    
    func bidmadAppOpenAdShow(_ core: BIDMADAppOpenAd!) {
        print("bidmadAppOpenAdShow")
    }
    
    func bidmadAppOpenAdClose(_ core: BIDMADAppOpenAd!) {
        print("bidmadAppOpenAdClose")
    }
    
    func bidmadAppOpenAdAllFail(_ core: BIDMADAppOpenAd!, code error: String!) {
        print("bidmadAppOpenAdAllFail")
    }
}
```
</details>

### Offerwall Ad Load and Currency Load

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@interface OfferwallController : UIViewController<BIDMADOfferwallDelegate>
...
@end
...
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"AppUI isSDKInit %d", [BIDMADOfferwall isSDKInit]);
    
    self.offerwall = [[BIDMADOfferwall alloc]initWithZoneId:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [self.offerwall setParentViewController:self];
    [self.offerwall setDelegate:self];
}
...
-(void)loadOfferwall {
    [offerwall loadOfferwall];
}
...
-(void)showOfferwall {
    if ([offerwall isLoaded]) {
      [offerwall showOfferwall];
    }
}
...
-(void)getCurrency {
    [offerwall getCurrencyBalance];
   
}
...
-(void)spendCurrency:(int)amount {
    [offerwall spendCurrency:amount];
}
...
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
class OfferwallController: UIViewController, BIDMADOfferwallDelegate {
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

    func getCurrency() {
        offerwall.getCurrencyBalance()
    }

    func spendCurrency(amount: Int) {
        offerwall.spendCurrency(Int32(amount))
    }
}
```
</details>

### Offerwall Callback Implementations

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADOfferwallInitSuccess:(BIDMADOfferwall *)core {
    NSLog(@"BIDMADOfferwallInitSuccess");
}

- (void)BIDMADOfferwallInitFail:(BIDMADOfferwall *)core error:(NSString *)error {
    NSLog(@"BIDMADOfferwallInitFail");
}

- (void)BIDMADOfferwallLoadAd:(BIDMADOfferwall *)core {
    NSLog(@"BIDMADOfferwallLoadAd");
}

- (void)BIDMADOfferwallShowAd:(BIDMADOfferwall *)core {
    NSLog(@"BIDMADOfferwallShowAd");
}

- (void)BIDMADOfferwallFailedAd:(BIDMADOfferwall *)core {
    NSLog(@"BIDMADOfferwallFailedAd");
}

- (void)BIDMADOfferwallCloseAd:(BIDMADOfferwall *)core {
    NSLog(@"BIDMADOfferwallCloseAd");
}

- (void)BIDMADOfferwallGetCurrencyBalanceSuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance {
    NSLog(@"BIDMADOfferwallGetCurrencyBalanceSuccess");    
}

- (void)BIDMADOfferwallGetCurrencyBalanceFail:(BIDMADOfferwall *)core error:(NSString *)error {
    NSLog(@"BIDMADOfferwallGetCurrencyBalanceFail");    
}

- (void)BIDMADOfferwallSpendCurrencySuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance {
    NSLog(@"BIDMADOfferwallSpendCurrencySuccess");    
}

- (void)BIDMADOfferwallSpendCurrencyFail:(BIDMADOfferwall *)core error:(NSString *)error {
    NSLog(@"BIDMADOfferwallSpendCurrencyFail");    
}
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
func bidmadOfferwallInitSuccess(_ core: BIDMADOfferwall!) {
    print("bidmadOfferwallInitSuccess");
}

func bidmadOfferwallInitFail(_ core: BIDMADOfferwall!, error: String!) {
    print("bidmadOfferwallInitFail");
}

func bidmadOfferwallLoadAd(_ core: BIDMADOfferwall!) {
    print("bidmadOfferwallLoadAd");
}

func bidmadOfferwallShowAd(_ core: BIDMADOfferwall!) {
    print("bidmadOfferwallShowAd");
}

func bidmadOfferwallFailedAd(_ core: BIDMADOfferwall!) {
    print("bidmadOfferwallFailedAd");
}

func bidmadOfferwallCloseAd(_ core: BIDMADOfferwall!) {
    print("bidmadOfferwallCloseAd");
}

func bidmadOfferwallGetCurrencyBalanceSuccess(_ core: BIDMADOfferwall!, currencyName: String!, balance: Int32) {
    print("bidmadOfferwallGetCurrencyBalanceSuccess");
}

func bidmadOfferwallGetCurrencyBalanceFail(_ core: BIDMADOfferwall!, error: String!) {
    print("bidmadOfferwallGetCurrencyBalanceFail");
}

func bidmadOfferwallSpendCurrencySuccess(_ core: BIDMADOfferwall!, currencyName: String!, balance: Int32) {
    print("bidmadOfferwallSpendCurrencySuccess");
}

func "bidmadOfferwallSpendCurrencyFail(_ core: BIDMADOfferwall!, error: String!) {
    print("bidmadOfferwallSpendCurrencyFail");
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
[BIDMADSetting.sharedInstance setTestDeviceId:"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"];

// Swift
BIDMADSetting.sharedInstance().testDeviceId = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

</details>

### References

</details>
<details markdown="1">
<summary>리스트</summary>
<br>

- [Class Reference for BidmadSDK-iOS](https://github.com/bidmad/Bidmad-iOS/wiki/README-ClassReference)
- Apple privacy survey ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/Apple-privacy-survey%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/Apple-privacy-survey%5BKOR%5D))
- iOS GDPR Guide ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/iOS-GDPR-Guide-%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/iOS-GDPR-Guide-%5BKOR%5D))
- Preparing for iOS 14 ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BKOR%5D))

</details>
