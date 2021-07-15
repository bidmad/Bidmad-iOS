# BidmadSDK iOS
## 퍼블리셔의 모바일 앱 기반 광고 수익 최적화를 위한 통합 앱수익화 솔루션

- 개요
    - BidmadSDK는 배너 · 전면 · 리워드 영상 · 오퍼월 광고 타입을 제공합니다. 이 문서는 BidmadSDK를 통한 구현 가이드를 제공합니다.
    - 현재 적용되어 있는 애드 네트워크 플랫폼은 다음과 같습니다.
        <details markdown="1">
        <summary>애드 네트워크 리스트</summary>
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

1. 개발 환경
    - Xcode 12.0 버전
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. SDK설치 방법
    - **(추천)** CocoaPods를 사용한 설치 방법

        1. Podfile 내부에 다음 코드 추가

            ```
            platform :ios, "11.0"

            target "Runner" do
             use_frameworks!
             pod "BidmadSDK", "2.8.0"
            ```

        2. Terminal에서 다음 커맨드 입력

            ```
            pod install
            ```

    - **(비추천)** 수동적인 Framework 추가 방법 **( 수동적인 Framework 추가 방법은 Swift를 지원하지 않습니다 )**
        1. Link Binary With Libraries 세팅에 다음 이미지와 같이 라이브러리 추가 ( Target → Build Phases → Link Binary With Libraries )<br>
            ![Link_Binary_With_Libraries](https://i.imgur.com/73OTB5n.png) <br>
        2. 프레임워크 및 번들을 다음 이미지와 같이 프로젝트에 추가 ( Target → General → Frameworks, Libraries, and Embedded Content )<br>
            ![Frameworks_Libraries_and_Embedded_Content](https://i.imgur.com/rWvmsaN.png)
        3. Copy Bundle Resources 에 다음 이미지와 같이 번들 리소스 추가 ( Target → Build Phases → Copy Bundle Resources )<br>
            ![Copy_Bundle_Resources](https://i.imgur.com/hoGfVJB.png)<br>
3. Build Settings ( Target → Build Settings )
    1. CocoaPods 사용자를 위한 세팅<br>
        - Enable Bitcode 를 No로 설정<br>
            ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>
    2. 수동적인 Framework 추가 방법 사용자를 위한 세팅<br>
        - Enable Bitcode 를 No로 설정<br>
            ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>
        - Other Linker Flag 에 -ObjC Flag 추가<br>
            ![Other_Linker](https://i.imgur.com/feieEZX.png)<br>
        - Allow Non-Modular Includes In Framework Modules 를 Yes로 설정<br>
            ![Allow_Non_Modular_Includes_In_Framework_Modules](https://i.imgur.com/ap4RddO.png)
4. info.plist 내용 설정

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
    
5. iOS 14 관련 셋업
    - iOS 14 업데이트 이후, App Tracking Transparency 세팅 및 SKAdNetwork info.plist 세팅이 필요하게 되었습니다. 다음 가이드로 참조하시어, 셋업을 진행해주세요.
    - [Preparing for iOS 14](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BKOR%5D)

## BidmadSDK Interface Guide

### 배너 광고 로드

<details markdown="1">
<summary>ObjC</summary>
<br>

1. 배너를 노출시킬 UIView를 UIViewController 상에 추가합니다 (UIView bannerContainer).
2. 배너 Initialize / ZoneID / Delegate 세팅 후, RequestBannerView를 호출해 배너를 로드 및 노출시킵니다. 
```
@interface BannerViewController : UIViewController<BIDMADBannerDelegate>
...
@end
...
__weak IBOutlet UIView *bannerContainer;
...
@implementation BannerViewController

- (void)viewDidLoad {
    ...
    // "bannerSize"는 "banner_320_50" 고정값만 전달해주십시오
    banner = [[BIDMADBanner alloc] initWithParentViewController:self rootView:bannerContainer bannerSize:banner_320_50];
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

1. 배너를 노출시킬 UIView를 UIViewController 상에 추가합니다 (UIView bannerContainer).
2. 배너 Initialize / ZoneID / Delegate 세팅 후, requestView를 호출해 배너를 로드 및 노출시킵니다. 
```
class BannerController: UIViewController, BIDMADBannerDelegate {
  var banner: BIDMADBanner
  var bannerContainer: UIView

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

### 배너 콜백 구현

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

### 전면 광고 로드

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

### 전면 광고 콜백 구현

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

### 보상형 비디오 광고 로드

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

### 보상형 비디오 콜백 구현

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

### 보상형 전면 광고 로드

보상형 전면 광고는 앱 내부 자연스러운 페이지 전환 시 자동으로 게재되는 광고를 통해 리워드를 제공할 수 있는 새로운 보상형 광고 형식입니다.<br>
보상형 광고와 달리 사용자는 수신 동의하지 않고도 보상형 전면 광고를 볼 수 있습니다.<br>
광고 시청에 대한 리워드를 공지하고 사용자가 원할 경우 광고 수신 해제할 수 있는 시작 화면이 필요합니다. (BidmadSDK 샘플 앱을 확인해주십시오)<br>
보상형 전면 광고 단위에는 건너뛸 수 있는 광고만 게재됩니다.<br>

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

### 보상형 전면 광고 콜백 구현<br>

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

### App Open 광고 로드
App Open 광고는 사용자가 앱을 포그라운드로 가져올 때, 앱 로드 화면으로 수익을 올리는 광고 형식입니다. <br>
App Open 광고는 사용자가 해당 앱을 사용 중임을 알 수 있도록 상단에 앱 로고를 표기합니다.<br>
BidmadSDK는 더 쉬운 App Open 광고 로드를 위해 registerForAppOpenAdForZoneID 메서드를 제공하고 있습니다.<br>
registerForAppOpenAdForZoneID 메서드는 사용자가 광고를 닫은 이후에도 다시 광고를 로드합니다.<br>

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

혹은 다음과 같이 수동으로 App Open 광고를 로드할 수 있습니다.
사용자가 광고를 닫은 이후 다시 광고가 로드되지 않기 때문에 BIDMADAppOpenAdClose 콜백을 받은 이후 다시 requestAppOpenAd 메서드를 호출해주십시오.

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

### AppOpen 광고 콜백 구현

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

### 오퍼월 광고 로드 및 화폐 로드

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

### Offerwall 콜백 구현

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

### 구글 애드네트워크 테스트 디바이스 설정
</details>
<details markdown="1">
<summary>세부사항</summary>
<br>

구글 애드네트워크를 위한 테스트 디바이스 설정은 다음과 같은 과정이 필요합니다.  

광고 통합 앱을 로드하고 광고를 요청합니다.
콘솔에서 다음과 같은 메시지를 확인합니다.

```
<Google> To get test ads on this device, set: GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" ];
```
콘솔에 기록된 테스트 디바이스 ID를 다음 코드를 통해 세팅하십시오.
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

