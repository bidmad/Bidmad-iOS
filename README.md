# BidmadSDK
### 바로가기
1. [SDK 세팅](#bidmadsdk-installation-guide)
    - [개발 환경](#개발-환경)
    - [SDK 설치 방법](#sdk-설치-방법)
2. [SDK 인터페이스 가이드](#bidmadsdk-interface-guide)
    - [앱 초기 구성 및 Migration](#앱-초기-구성-및-migration)
    - [BidmadSDK 초기화](#bidmadsdk-초기화)
    - [배너 광고](#배너-광고)
    - [전면 광고](#전면-광고)
    - [보상형 비디오 광고](#보상형-비디오-광고)
    - [App Open 광고](#app-open-광고)
    - [Native Ad 광고](#native-ad-광고)
    - [구글 애드네트워크 테스트 디바이스 설정](#구글-애드네트워크-테스트-디바이스-설정)
3. [참고사항](#참고사항)
4. [최신 샘플 프로젝트 다운로드](https://github.com/bidmad/Bidmad-iOS/archive/refs/heads/main.zip)
---

## BidmadSDK Installation Guide

#### 개발 환경
- Xcode 13.2 버전 (Xcode 최소 사양 13.2)
- BASE SDK : iOS
- iOS Deployment Target : 11.0
#### SDK 설치 방법
1. Podfile 내부에 다음 코드 추가 (Xcode 13.4.1 이상 버전)

```
platform :ios, "11.0"

target "Runner" do
  use_frameworks!
  pod 'BidmadSDK', '5.1.0'
  pod 'OpenBiddingHelper', '5.1.0'
  pod 'BidmadAdapterFC', '5.1.0'
  pod 'BidmadAdapterFNC', '5.1.0'
```

2. Terminal에서 다음 커맨드 입력

```
pod install
```
    
3. Build Settings ( Target → Build Settings ) <br>
    - Enable Bitcode 를 No로 설정<br>
        ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>

## BidmadSDK Interface Guide

### 앱 초기 구성 및 Migration<br>
앱 초기 구성에 앞서, 4.6.0.1 이하 버전에서 5.0.0 버전으로 업데이트하는 경우 [API Migration Guide](https://github.com/bidmad/Bidmad-iOS/wiki/v5.0.0-API-Migration-Guide-%5BKR%5D) 를 참고해 앱 업데이트를 진행하십시오. 이후, 아래 info.plist 내부 BidmadAppKey 추가 및 initializeSdk 메서드 추가 과정도 거치십시오.<br>

Xcode 프로젝트 info.plist 에 다음 키를 포함합니다.<br>
1. ADOP Insight 에서 확인할 수 있는 iOS 용 AppKey ("[App Key 찾기](https://github.com/bidmad/SDK/wiki/Find-your-app-key%5BKR%5D)" 가이드를 참고하십시오) <br>

```
<key>BidmadAppKey</key>
<string>xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx</string>
```

2. AdMob 대시보드 UI에서 확인 가능한 iOS 용 애드몹 ID ("[App Key 찾기](https://github.com/bidmad/SDK/wiki/Find-your-app-key%5BKR%5D)" 가이드를 참고하십시오) <br>

```
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx</string>
```

3. BidmadSDK에서 지원하는 광고 네트워크에 대한 SKAdNetworkIdentifier 값이 포함된 SKAdNetworkItems 키 ([Preparing for iOS 14](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BENG%5D) 를 참고하십시오)<br>

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

### BidmadSDK 초기화<br>
BidmadSDK 실행에 필요한 작업을 수행합니다. SDK는 initializeSdk 메서드를 호출하지 않은 경우 광고 로드를 허용하지 않습니다.<br>
초기화는 앱 실행 시 한번만 하는 것이 좋습니다. 다음은 initializeSdk 메서드를 호출하는 방법의 예시입니다.<br>

```
// Objective C
[BidmadCommon initializeSdk];

// Swift
BidmadCommon.initializeSdk()
```

### 배너 광고
1. 배너를 노출시킬 UIView를 UIViewController 상에 추가합니다 (UIView bannerContainer).
2. 배너 Initialize / ZoneID / Delegate 세팅 후, RequestBannerView를 호출해 배너를 로드 및 노출시킵니다.

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

### 전면 광고
1. 전면 광고를 노출시키기 전, load 메서드를 호출합니다.
2. onLoadAd 콜백 수신 이후, show(on:) 메서드를 호출해 미리 로드된 전면 광고를 디스플레이 합니다. 

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

### 보상형 비디오 광고
1. 보상형 광고를 노출시키기 전, load 메서드를 호출합니다.
2. onLoadAd 콜백 수신 이후, show(on:) 메서드를 호출해 미리 로드된 보상형 광고를 디스플레이 합니다.
3. onSkipAd (사용자가 광고를 스킵함) 혹은 onCompleteAd (사용자가 보상 지급 자격을 받음) 콜백에 따라 사용자에게 보상을 지급합니다.

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

### App Open 광고
App Open 광고는 사용자가 앱을 포그라운드로 가져올 때, 앱 로드 화면으로 수익을 올리는 광고 형식입니다. App Open 광고는 사용자가 해당 앱을 사용 중임을 알 수 있도록 상단에 앱 로고를 표기합니다. BidmadSDK는 더 쉬운 App Open 광고 로드를 위해 BidmadAppOpenAd init 시, 바로 AppOpenAd를 로드합니다. 사용자가 앱을 닫고 다시 열어 광고를 시청한 이후에도, 다시 AppOpenAd 광고를 로드합니다.

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
        [self.appOpenAd show];
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
            appOpenAd.show()
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

### Native Ad 광고
네이티브 광고는 애플리케이션에 맞는 고유한 방식으로 기획, 제작된 광고를 말합니다. 광고를 호출하기 앞서, [레이아웃 가이드](https://github.com/bidmad/Bidmad-iOS/wiki/Native-Ad-Layout-Setting-Guide-%5BKOR%5D)에 따라 광고 UI 설정해주십시오. 광고 UI 설정 이후, 광고 데이터가 포함된 BIDMADNativeAd 를 로드한 뒤, setAdView:adView: 메서드를 실행합니다.

<details markdown="1">
<summary>Sample Code (Load & Callbacks)</summary>
<br>

```
// Objective C

@import OpenBiddingHelper; 

@interface NativeAdViewController ()
@property (strong, nonatomic) BidmadNativeAdLoader *adLoader;
@end
...

- (void)viewDidLoad {
    self.adLoader = [BidmadNativeAdLoader new];
    self.adLoader.delegate = self;
    self.adLoader.numberOfAds = 5;
    
    [self.adLoader requestAd:@"7fe8f6de-cd99-4769-9ae6-a471cfd7e2b1"];
}

#pragma mark Native Ad Delegate Methods

- (void)onClickAd:(BIDMADNativeAd *)bidmadAd {
    ADOPLog.printInfo(@"Native Ad Click: %@", bidmadAd.adData.description);
}

- (void)onLoadAd:(BIDMADNativeAd *)bidmadAd {
    ADOPLog.printInfo(@"Native Ad Load: %@", bidmadAd.adData.description);
    
    BIDMADNativeAdView *view = [NSBundle.mainBundle loadNibNamed:@"NativeAdView" owner:nil options:nil].firstObject;
    [self.adLoader setAdView:self adView:view];
}

- (void)onLoadFailAd:(BIDMADNativeAd *)bidmadAd error:(NSError *)error {
    ADOPLog.printInfo(@"Native Ad Fail: %@", error.localizedDescription);
}

// Swift

let adLoader = BidmadNativeAdLoader()

override func viewDidLoad() {
    super.viewDidLoad()

    adLoader.delegate = self
    adLoader.numberOfAds = 1
    
    // Insert your own zoneID as an argument in the method, 'requestAd:(NSString *)'
    adLoader.requestAd("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
}

// MARK: BIDMADNativeAdDelegate

func onLoad(_ bidmadAd: BIDMADNativeAd) {
    guard let nativeAdView = Bundle.main.loadNibNamed("NativeAdView", owner: nil)?.first as? BIDMADNativeAdView else {
        return
    }

    self.adLoader.setAdView(self, adView: nativeAdView)
}

func onClick(_ bidmadAd: BIDMADNativeAd) {
    print("Native Ad Click: \(bidmadAd.adData?.headline ?? "No Headline")")
}

func onLoadFail(_ bidmadAd: BIDMADNativeAd, error: Error) {
    print("Native Ad Fail: \(error.localizedDescription)")
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

