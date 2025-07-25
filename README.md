> [!IMPORTANT]
> BidmadSDK-iOS v6.11.0 부터, 이전 버전에서 사용되던 AppKey는 AppDomain으로 변경되었습니다.<br>
> **AppDomain은 기존 Appkeys와 호환되지 않으므로 BidmadSDK를 초기화하기 위해선 새로운 AppDomain을 발급받아야 합니다.**<br>
> BidmadSDK-iOS v6.11.0 으로 업데이트하는 경우 **Techlabs 플랫폼 운영팀**에 문의해주세요.
> BidmadSDK-iOS v6.12.4 부터, iOS 13.0 이상을 요구합니다.

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
- Xcode 최소 사양 16.0
- BASE SDK : iOS
- iOS Deployment Target : 13.0
#### SDK 설치 방법
1. Podfile 내부에 다음 코드 추가

```
# 사용하시는 최소 iOS 버전을 아래 라인에 기입해주세요
platform :ios, "12.0"

target "BidmadSDKTest" do

  use_frameworks!
  pod "BidmadSDK", "6.12.4"
  pod "OpenBiddingHelper", "6.12.3"
  pod "BidmadAdFitAdapter", "3.12.7.11.0"
  pod "BidmadAdmixerAdapter", "2.0.2.11.1"
  pod "BidmadAppLovinAdapter", "13.3.1.11.0"
  pod "BidmadFyberAdapter", "8.3.7.11.0"
  pod "BidmadGoogleAdManagerAdapter", "12.6.0.11.0"
  pod "BidmadGoogleAdMobAdapter", "12.6.0.11.0"
  pod "BidmadMobwithAdapter", "1.0.0.11.2"
  pod "BidmadORTBAdapter", "1.0.0.11.2"
  pod "BidmadPangleAdapter", "7.2.0.5.11.0"
  pod "BidmadTaboolaAdapter", "3.8.33.11.2"
  pod "BidmadTeadsAdapter", "5.2.0.11.2"
  pod "BidmadUnityAdsAdapter", "4.15.0.11.0"
  pod "BidmadVungleAdapter", "7.5.1.11.0"
  pod "BidmadPartners/AdMobBidding", "1.0.7"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 사용하시는 최소 iOS 버전을 아래 라인에 기입해주세요
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end

```

  * 6.4.0 이상 버전부터 BidmadAdapterFNC, BidmadAdapterFC, BidmadAdapterDynamic 을 지원하지 않습니다. 6.3.X 이하 버전에서 6.4.0 이상 버전으로 업데이트를 원하시는 사용자는 "BidmadAdapterFNC, BidmadAdapterFC, BidmadAdapterDynamic" 의존성을 제거하고, 위에 기재된 의존성을 추가해 어댑터를 추가해주세요.

2. Terminal에서 다음 커맨드 입력

```
pod install
```
    
3. Build Settings ( Target → Build Settings ) <br>
    - Enable Bitcode 를 No로 설정<br>
        ![Enable_Bitcode](https://i.imgur.com/aXOBmr1.png)<br>

#### 앱 제출 및 개인정보 보호 설문조사
App Store에 애플리케이션을 제출할 때 다음 가이드를 참고하여 개인 정보 보호 정책 및 설문조사를 올바르게 설정하세요. [Guide for Privacy Manifest & Privacy Survey](https://github.com/bidmad/Bidmad-iOS/wiki/Guide-for-Privacy-Manifest-&-Privacy-Survey-%5BKR%5D)

## BidmadSDK Interface Guide

### 앱 초기 구성 및 Migration<br>
앱 초기 구성에 앞서, 4.6.0.1 이하 버전에서 5.0.0 버전으로 업데이트하는 경우 [API Migration Guide](https://github.com/bidmad/Bidmad-iOS/wiki/v5.0.0-API-Migration-Guide-%5BKR%5D) 를 참고해 앱 업데이트를 진행하십시오. 이후, 아래 info.plist 내부 BidmadAppKey 추가 및 initializeSdk 메서드 추가 과정도 거치십시오.<br>

5.3.0 버전 이하에서 6.0.0 버전 이상으로 업데이트하시는 네이티브 광고 인터페이스 사용자의 경우 [NativeAd Migration Guide 6.0.0](https://github.com/bidmad/Bidmad-iOS/wiki/Native-Ad-Migration-to-v6.0.0%5BKOR%5D) 를 참고해 앱 업데이트를 진행하십시오.

6.3.5 버전 이하에서 6.4.0 버전 이상으로 업데이트하시는 앱오픈 광고 / 네이티브 광고 인터페이스 사용자의 경우 [AppOpen and NativeAd Migration Guide for 6.4.0](https://github.com/bidmad/Bidmad-iOS/wiki/AppOpen-and-NativeAd-Migration-Guide-for-6.4.0-%5BKOR%5D)를 참고해 앱 업데이트를 진행하십시오. 

1. Techlabs 운영팀으로부터 전달받은 AppDomain 값을 다음과 같이 info.plist에 기입하십시오.<br>

```
<key>BidmadAppDomain</key>
<string>**YOUR-APP-DOMAIN**</string>
```

2. AdMob 대시보드 UI에서 확인 가능한 iOS 용 애드몹 ID ("[App Key 찾기](https://github.com/bidmad/SDK/wiki/Find-your-app-key%5BKR%5D)" 가이드를 참고하십시오) <br>

```
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx</string>
```

3. BidmadSDK에서 지원하는 광고 네트워크에 대한 SKAdNetworkIdentifier 값이 포함된 SKAdNetworkItems 키 ([Preparing for iOS 14](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BKOR%5D) 를 참고하십시오)<br>

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

// -- SWIFT --
BidmadCommon.initializeSdk()
```

또한, 아래 인터페이스를 통해 initializeSdk 성공 여부 콜백을 전달받을 수 있습니다.<br>

```
// Objective C
[BidmadCommon initializeSdkWithCompletionHandler:^(BOOL isInitialized) {
    NSLog(@"Bidmad Sample App: Initialized %@", isInitialized ? @"YES" : @"NO");
}];

// -- SWIFT --
BidmadCommon.initializeSdk { isInitialized in
    print("Bidmad Sample App: \(isInitialized)")
}
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

// -- SWIFT --

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

- (void)onLoadAd:(OpenBiddingBanner *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Load")
}

- (void)onClickAd:(OpenBiddingBanner *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Click")
}

- (void)onLoadFailAd:(OpenBiddingBanner *)bidmadAd error:(NSError *)error {
    NSLog(@"LoadFail")
}

// -- SWIFT --

func onLoadAd(_ bidmadAd: OpenBiddingBanner, info: BidmadInfo) {
    print("ad is loaded")
}

func onLoadFailAd(_ bidmadAd: OpenBiddingBanner, error: any Error) {
    print("ad failed to load with error \(error.localizedDescription)")
}

func onClickAd(_ bidmadAd: OpenBiddingBanner, info: BidmadInfo) {
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

// -- SWIFT --

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

- (void)onLoadAd:(OpenBiddingInterstitial *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Load");
}

- (void)onLoadFailAd:(OpenBiddingInterstitial *)bidmadAd error:(NSError *)error {
    NSLog(@"Load Fail");
}

- (void)onShowAd:(OpenBiddingInterstitial *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Show");
}

- (void)onClickAd:(OpenBiddingInterstitial *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Click");
}

- (void)onCloseAd:(OpenBiddingInterstitial *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Close");
}

// onShowFailAd:error: 콜백은 v6.6.0 이상에서만 사용할 수 있습니다.
- (void)onShowFailAd:(OpenBiddingInterstitial *)bidmadAd info:(BidmadInfo *)info error:(NSError *)error {
    NSLog(@"Show Fail");
}

// -- SWIFT --

func onLoadAd(_ bidmadAd: OpenBiddingInterstitial, info: BidmadInfo) {
    print("ad is loaded")
}

func onLoadFailAd(_ bidmadAd: OpenBiddingInterstitial, error: any Error) {
    print("ad failed to load with error \(error.localizedDescription)")
}

func onShowAd(_ bidmadAd: OpenBiddingInterstitial, info: BidmadInfo) {
    print("ad is shown")
}

func onClickAd(_ bidmadAd: OpenBiddingInterstitial, info: BidmadInfo) {
    print("ad is clicked")
}

func onCloseAd(_ bidmadAd: OpenBiddingInterstitial, info: BidmadInfo) {
    print("ad is closed")
}

// onShowFailAd:error: 콜백은 v6.6.0 이상에서만 사용할 수 있습니다.
func onShowFailAd(_ bidmadAd: OpenBiddingInterstitial,, info: BidmadInfo, error: Error) {
    print("ad display failed")
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

// -- SWIFT --

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

- (void)onLoadAd:(OpenBiddingRewardVideo *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Load");
}

- (void)onLoadFailAd:(OpenBiddingRewardVideo *)bidmadAd error:(NSError *)error {
    NSLog(@"Load Fail");
}

- (void)onShowAd:(OpenBiddingRewardVideo *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Show");
}

- (void)onClickAd:(OpenBiddingRewardVideo *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Click");
}

- (void)onCompleteAd:(OpenBiddingRewardVideo *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Complete");
}

- (void)onSkipAd:(OpenBiddingRewardVideo *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Skip");
}

- (void)onCloseAd:(OpenBiddingRewardVideo *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Close");
}

// onShowFailAd:error: 콜백은 v6.6.0 이상에서만 사용할 수 있습니다.
- (void)onShowFailAd:(OpenBiddingRewardVideo *)bidmadAd info:(BidmadInfo *)info error:(NSError *)error {
    NSLog(@"Show Fail");
}

// -- SWIFT --

func onLoadAd(_ bidmadAd: OpenBiddingRewardVideo, info: BidmadInfo) {
    print("ad is loaded")
}

func onLoadFailAd(_ bidmadAd: OpenBiddingRewardVideo, error: Error) {
    print("ad failed to load with error \(error.localizedDescription)")
}

func onShowAd(_ bidmadAd: OpenBiddingRewardVideo, info: BidmadInfo) {
    print("ad is shown")
}

func onClickAd(_ bidmadAd: OpenBiddingRewardVideo, info: BidmadInfo) {
    print("ad is clicked")
}

func onCompleteAd(_ bidmadAd: OpenBiddingRewardVideo, info: BidmadInfo) {
    print("ad reward is completed")
}

func onSkipAd(_ bidmadAd: OpenBiddingRewardVideo, info: BidmadInfo) {
    print("ad reward is skipped")
}

func onCloseAd(_ bidmadAd: OpenBiddingRewardVideo, info: BidmadInfo) {
    print("ad is closed")
}

// onShowFailAd:error: 콜백은 v6.6.0 이상에서만 사용할 수 있습니다.
func onShowFailAd(_ bidmadAd: OpenBiddingRewardVideo, info: BidmadInfo, error: Error) {
    print("ad display failed")
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
    
    self.appOpenAd = [[BidmadAppOpenAd alloc] initWithZoneID:@"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
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

// -- SWIFT --

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
- (void)onLoadAd:(OpenBiddingAppOpenAd *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Load");
}

- (void)onShowAd:(OpenBiddingAppOpenAd *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Show");
}

- (void)onClickAd:(OpenBiddingAppOpenAd *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Click");
}

- (void)onCloseAd:(OpenBiddingAppOpenAd *)bidmadAd info:(BidmadInfo *)info {
    NSLog(@"Close");
}

- (void)onLoadFailAd:(OpenBiddingAppOpenAd *)bidmadAd error:(NSError *)error {
    NSLog(@"Load Fail");
}

// onShowFailAd:error: 콜백은 v6.6.0 이상에서만 사용할 수 있습니다.
- (void)onShowFailAd:(OpenBiddingAppOpenAd *)bidmadAd info:(BidmadInfo *)info error:(NSError *)error {
    NSLog(@"Show Fail");
}

// -- SWIFT --

func onLoadAd(_ bidmadAd: OpenBiddingAppOpenAd, info: BidmadInfo) {
    print("ad is loaded")
}

func onLoadFailAd(_ bidmadAd: OpenBiddingAppOpenAd, error: Error) {
    print("ad failed to load with error \(error.localizedDescription)")
}

func onShowAd(_ bidmadAd: OpenBiddingAppOpenAd, info: BidmadInfo) {
    print("ad is shown")
}

func onClickAd(_ bidmadAd: OpenBiddingAppOpenAd, info: BidmadInfo) {
    print("ad is clicked")
}

func onCloseAd(_ bidmadAd: OpenBiddingAppOpenAd, info: BidmadInfo) {
    print("ad is closed")
}

// onShowFailAd:error: 콜백은 v6.6.0 이상에서만 사용할 수 있습니다.
func onShowFail(_ bidmadAd: OpenBiddingAppOpenAd, info: BidmadInfo, error: Error) {
    print("ad display failed")
}
```
</details>

### Native Ad 광고
네이티브 광고는 애플리케이션에 맞는 고유한 방식으로 기획, 제작된 광고를 말합니다. 광고를 호출하기 앞서, [레이아웃 가이드](https://github.com/bidmad/Bidmad-iOS/wiki/Native-Ad-Layout-Setting-Guide-%5BKOR%5D)에 따라 광고 UI 설정해주십시오. 광고 UI 설정 이후, 광고 데이터가 포함된 BIDMADNativeAd 를 로드한 뒤, setAdView:adView: 메서드를 실행합니다.

*5.3.0 버전 이하에서 6.0.0 버전 이상으로 업데이트하시는 네이티브 광고 인터페이스 사용자의 경우 [NativeAd Migration Guide 6.0.0](https://github.com/bidmad/Bidmad-iOS/wiki/Native-Ad-Migration-to-v6.0.0%5BKOR%5D) 를 참고해 앱 업데이트를 진행하십시오.

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

- (void)onClickAd:(BidmadNativeAd *)bidmadAd info:(BidmadInfo *)info {
    ADOPLog.printInfo(@"Native Ad Click");
}

- (void)onLoadAd:(BidmadNativeAd *)bidmadAd info:(BidmadInfo *)info {
    ADOPLog.printInfo(@"Native Ad Load);
    
    UIView *loadedView = [NSBundle.mainBundle loadNibNamed:@"NativeAdView" owner:nil options:nil].firstObject;
    BIDMADNativeAdView *adView = [BidmadNativeAd findAdViewFromSuperview:loadedView];
    
    [self.view addSubview:loadedView];
    [bidmadAd setRootViewController:self adView:adView];
}

- (void)onLoadFailAd:(BidmadNativeAd *)bidmadAd error:(NSError *)erro {
    ADOPLog.printInfo(@"Native Ad Fail: %@", error.localizedDescription);
}

// -- SWIFT --

let ad: BidmadNativeAd! = BidmadNativeAd(zoneID: "Native Ad Zone ID")

override func viewDidLoad() {
    super.viewDidLoad()

    self.ad.delegate = self
    self.ad.load()
}

// MARK: BIDMADNativeAdDelegate

func onLoad(_ bidmadAd: BidmadNativeAd, info: BidmadInfo) {
    if let loadedView = Bundle.main.loadNibNamed("NativeAd", owner: nil)?.first as? UIView,
       let adView = BidmadNativeAd.findView(fromSuperview: loadedView) {
        view.addSubview(loadedView)
        self.ad.setRootViewController(self, adView: adView)
    }
}

func onClick(_ bidmadAd: BidmadNativeAd, info: BidmadInfo) {
    print("Native Ad Click")
}

func onLoadFail(_ bidmadAd: BidmadNativeAd, error: any Error) {
    print("Native Ad Fail")
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

// -- SWIFT --
BidmadCommon.setTestDeviceId("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
```

</details>

### 참고사항

</details>
<details markdown="1">
<summary>리스트</summary>
<br>

- [Class Reference for BidmadSDK-iOS](https://github.com/bidmad/Bidmad-iOS/wiki/README-ClassReference%5BKOR%5D)
- Apple privacy survey ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/Apple-privacy-survey%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/Apple-privacy-survey%5BKOR%5D))
- iOS GDPR Guide ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/iOS-GDPR-Guide-%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/iOS-GDPR-Guide-%5BKOR%5D))
- Preparing for iOS 14 ([[ENG]](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BENG%5D) | [[KOR]](https://github.com/bidmad/Bidmad-iOS/wiki/Preparing-for-iOS-14%5BKOR%5D))
- [쿠팡 네트워크 광고 차단 인터페이스 가이드](https://github.com/bidmad/Bidmad-iOS/wiki/쿠팡-네트워크-광고-차단-인터페이스-가이드)
</details>

