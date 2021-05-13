# BidmadSDK iOS
## Integrated App Monetization Solution for Mobile Apps by all Publishers

- Introduction
    - BidmadSDK offers Banner · Interstitial · Reward Video · Offerwall ad types. This document provides an instruction on integrating BidmadSDK into your app.
    - Currently the following list of ad networks are integrated into our SDK.
        <details markdown="1">
        <summary>Ad Network Lists</summary>
        <br>
        
        - GoogleManager (Banner, Interstitial, Reward Video)
        - GoogleAdmob (Banner, Interstitial, Reward Video)
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
3. Build Settings 
    1. CocoaPods
        - Set 'Enable Bitcode' to No
    2. Manual Framework Import
        - Set 'Enable Bitcode' to No
        - Add -ObjC Flag to Other Linker Flag
        - Set 'Allow Non-Modular Includes In Framework Modules' to Yes
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

### 참고사항

</details>
<details markdown="1">
<summary>리스트</summary>
<br>

- [Class Reference for BidmadSDK-iOS](https://github.com/bidmad/Bidmad-iOS/wiki/README-ClassReference)
- Apple privacy survey ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/Apple-privacy-survey%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/Apple-privacy-survey%5BKOR%5D))
- iOS GDPR Guide ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/iOS-GDPR-Guide-%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/iOS-GDPR-Guide-%5BKOR%5D))
- Preparing for iOS 14 ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BKOR%5D))

</details>
