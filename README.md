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
        - AdColony (Banner, Interstitial, Reward Video)
        - ADOPAtom (Interstitial, Reward Video)
        - AdFit (Banner)
        - Tapjoy (Offerwall)
        - Fyber (Banner, Interstitial, Reward Video)
        </details>
        
## BidmadSDK Installation Guide

1. 개발 환경
    - Xcode 13.2 버전 (Xcode 최소 사양 12.2)
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. SDK설치 방법 <br>
    1-1. Podfile 내부에 다음 코드 추가 (Xcode 13 이상 버전)

        ```
        platform :ios, "11.0"

        target "Runner" do
         use_frameworks!
         pod 'BidmadSDK', '4.1.1.3'
         pod 'OpenBiddingHelper', '4.1.1.2'
         pod 'BidmadAdapterFC', '4.1.1.4'
         pod 'BidmadAdapterFNC', '4.1.1.4'
        ```
    
    1-2. Podfile 내부에 다음 코드 추가 (Xcode 13 미만 버전) 

        ```
        platform :ios, "11.0"

        target "Runner" do
         use_frameworks!
         pod 'BidmadSDK', '4.1.1.2'
         pod 'OpenBiddingHelper', '4.1.1.2'
         pod 'BidmadAdapterFC/Xcode12Compatibility', '4.1.1.4'
         pod 'BidmadAdapterFNC', '4.1.1.4'
        ```

    2. Terminal에서 다음 커맨드 입력

        ```
        pod install
        ```
        
3. Build Settings ( Target → Build Settings ) <br>
    - Enable Bitcode 를 No로 설정<br>
        ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>
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

### Initialize SDK 호출
앱 시작 시 CommonInterface 에서 initializeSdk() 함수를 호출합니다.
initializeSdk를 호출하지 않는 경우, SDK 자체적으로 수행하기 때문에 초회 광고 로딩이 늦어질 수 있습니다.

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

전면 또는 보상형 광고를 사용하시는 경우에는 원활한 광고 노출을 위해 initializeSdk() 호출 대신
아래 전면 / 보상형 광고 가이드에 따라 앱 시작 시점에서 광고를 Load 하시고 원하시는 시점에 Show하시기 바랍니다.

### Auto Reload 기능
전면 / 보상형 / 보상형 전면 광고 (풀스크린 광고) 의 경우, 광고가 사용자에게 디스플레이된 이후 자동으로 로드 과정을 거칠 수 있도록 설정되어 있습니다.
해당 기능은 다음 인터페이스를 통해 자유롭게 ON / OFF 할 수 있습니다. 다음 인터페이스의 Default 값은 true (Swift) / YES (ObjC) 입니다.

<details markdown="1">
<summary>ObjC</summary>
<br>
 
```
[fullscreenAd setIsAutoReload: YES]; // Auto Reload 기능 사용
[fullscreenAd setIsAutoReload: NO]; // Auto Reload 기능 사용하지 않음
```
</details>

<details markdown="1">
<summary>Swift</summary>
<br>

```
fullscreenAd.isAutoReload = true // Auto Reload 기능 사용
fullscreenAd.isAutoReload = false // Auto Reload 기능 사용하지 않음
```
</details>

### 배너 광고 로드

<details markdown="1">
<summary>ObjC</summary>
<br>

1. 배너를 노출시킬 UIView를 UIViewController 상에 추가합니다 (UIView bannerContainer).
2. 배너 Initialize / ZoneID / Delegate 세팅 후, RequestBannerView를 호출해 배너를 로드 및 노출시킵니다. 
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

1. 배너를 노출시킬 UIView를 UIViewController 상에 추가합니다 (UIView bannerContainer).
2. 배너 Initialize / ZoneID / Delegate 세팅 후, requestView를 호출해 배너를 로드 및 노출시킵니다. 
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

### 배너 콜백 구현

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

### 전면 광고 로드

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

### 전면 광고 콜백 구현

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

### 보상형 비디오 광고 로드

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

### 보상형 비디오 콜백 구현

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

### 보상형 전면 광고 로드

보상형 전면 광고는 앱 내부 자연스러운 페이지 전환 시 자동으로 게재되는 광고를 통해 리워드를 제공할 수 있는 새로운 보상형 광고 형식입니다.<br>
보상형 광고와 달리 사용자는 수신 동의하지 않고도 보상형 전면 광고를 볼 수 있습니다.<br>
광고 시청에 대한 리워드를 공지하고 사용자가 원할 경우 광고 수신 해제할 수 있는 시작 화면이 필요합니다. (BidmadSDK 샘플 앱을 확인해주십시오)<br>
보상형 전면 광고 단위에는 건너뛸 수 있는 광고만 게재됩니다.<br>

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

### 보상형 전면 광고 콜백 구현<br>

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

### App Open 광고 로드
App Open 광고는 사용자가 앱을 포그라운드로 가져올 때, 앱 로드 화면으로 수익을 올리는 광고 형식입니다. <br>
App Open 광고는 사용자가 해당 앱을 사용 중임을 알 수 있도록 상단에 앱 로고를 표기합니다.<br>
BidmadSDK는 더 쉬운 App Open 광고 로드를 위해 BidmadAppOpenAd init 시, 바로 AppOpenAd를 로드합니다.<br>
사용자가 앱을 닫고 다시 열어 광고를 시청한 이후에도, 다시 AppOpenAd 광고를 로드합니다.<br>

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

혹은 다음과 같이 수동으로 App Open 광고를 로드할 수 있습니다.
사용자가 광고를 닫은 이후 다시 광고가 로드되지 않기 때문에 BIDMADAppOpenAdClose 콜백을 받은 이후 다시 requestAppOpenAd 메서드를 호출해주십시오.

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

### AppOpen 광고 콜백 구현

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

### 오퍼월 광고 로드 및 화폐 로드

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

### Offerwall 콜백 구현

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
[BidmadCommon setTestDeviceId:@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"];

// Swift
BidmadCommon.setTestDeviceId("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
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

