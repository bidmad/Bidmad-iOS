# BidmadSDK iOS
## 퍼블리셔의 모바일 앱 기반 광고 수익 최적화를 위한 통합 앱수익화 솔루션

- 개요
    - BidmadSDK는 배너 · 전면 · 리워드 영상 · 오퍼월 광고 타입을 제공합니다. 이 문서는 BidmadSDK를 통한 구현 가이드를 제공합니다.
    - 현재 적용되어 있는 애드 네트워크 플랫폼은 다음과 같습니다.
        <details markdown="1">
        <summary>애드 네트워크 리스트</summary>
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

1. 개발 환경
    - Xcode 12.0 버전
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. SDK설치 방법
    - **(추천)** CocoaPods를 사용한 설치 방법

        1. Podfile 내부에 다음 코드 추가

            ```
            platform :ios, "10.0"

            target "Runner" do
             use_frameworks!
             pod "BidmadSDK", "2.6.3"
            ```

        2. Terminal에서 다음 커맨드 입력

            ```
            pod install
            ```

    - **(비추천)** 수동적인 Framework 추가 방법
        1. 프레임워크 및 번들을 아래 첨부 그림과 같이 프로젝트에 추가

            ![BidmadSDK%20Interface%20Guide%200fab5e4337eb4ee291be98969dbc7a78/Screenshot_of_Xcode_(2021-05-12_3-10-19_PM).png](https://drive.google.com/uc?export=view&id=1t63jauRPErG2Nf5MUM_mcf1KFpp4ecC_)

        2. Embedded Binaries에 BidmadSDK.framework 추가
        3. 아래 항목을 Build Phases 탭에 있는 Copy Bundle Resources에 "bidmad_asset.bundle" 추가
3. Build Settings 
    1. CocoaPods
        - Enable Bitcode 를 No로 설정
    2. Manual Framework Import
        - Enable Bitcode 를 No로 설정
        - Other Linker Flag 에 -ObjC Flag 추가
        - Allow Non-Modular Includes In Framework Modules 를 Yes로 설정
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

- [Class Reference for BidmadSDK-iOS](https://github.com/bidmad/Bidmad-iOS/blob/main/README-Pages/README-ClassReference.md)
- [BidmadSDK - Get Started [ENG]](https://github.com/bidmad/Bidmad-iOS/blob/main/README-Pages/README(ENG).md)
- iOS GDPR Guide ([KOR](https://github.com/bidmad/Bidmad-iOS/blob/main/README-Pages/iOS-GDPR-Guide-%5BKOR%5D.md)|[ENG](https://github.com/bidmad/Bidmad-iOS/blob/main/README-Pages/iOS-GDPR-Guide-%5BENG%5D.md))
- Apple Privacy Survey ([ENG](https://github.com/bidmad/Bidmad-iOS/blob/main/README-Pages/Apple-privacy-survey%5BENG%5D.md)|[KOR](https://github.com/bidmad/Bidmad-iOS/blob/main/README-Pages/Apple-privacy-survey%5BKOR%5D.md))

</details>

