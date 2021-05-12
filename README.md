# BidmadSDK iOS
## 퍼블리셔의 모바일 앱 기반 광고 수익 최적화를 위한 통합 앱수익화 솔루션

1. 개요
    - Bidmad SDK IOS 버전을 프로젝트에 적용하는 Guide 문서. 현재 적용 되어 있는 광고 플랫폼은 다음과 같다.
        - GoogleManager (Banner, Interstitial, Reward)
        - GoogleAdmob (Banner, Interstitial, RewardVideo)
        - AppLovin (RewardVideo)
        - UnityAds (RewardVideo, Banner)
        - Facebook Audience Network (Banner, Interstitial, Reward)
        - ADOPAtom (Interstitial, RewardVideo)
        - Tapjoy (Offerwall)
    - BIDMAD SDK IOS버전은 띠배너 <320Ⅹ50, 300Ⅹ250> 와 전면광고, 보상형 비디오 광고, 오퍼월 광고를 제공한다.

## BidmadSDK Installation Guide

1. 개발 환경
    - Xcode 12.0 버전
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. SDK설치 방법
    - **(추천)** CocoaPods를 사용한 설치 방법

        Podfile 내부에 다음 코드 추가

        ```
        platform :ios, "10.0"

        target "Runner" do
         use_frameworks!
         pod "BidmadSDK", "2.6.3"
        ```

        Terminal에서 다음 커맨드 입력

        ```
        pod install
        ```

    - **(비추천)** 수동적인 Framework 추가 방법
        1. 프레임워크 및 번들을 아래 첨부 그림과 같이 프로젝트에 추가

            ![BidmadSDK%20Interface%20Guide%200fab5e4337eb4ee291be98969dbc7a78/Screenshot_of_Xcode_(2021-05-12_3-10-19_PM).png](https://drive.google.com/uc?export=view&id=1t63jauRPErG2Nf5MUM_mcf1KFpp4ecC_)

        2. Embedded Binaries에 BidmadSDK.framework 추가
        3. 아래 항목을 Build Phases 탭에 있는 Copy Bundle Resources에 "bidmad_asset.bundle" 추가
3. info.plist 내용 설정

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
        - Enable Bitcode 를 No로 설정
    2. Manual Framework Import
        - Enable Bitcode 를 No로 설정
        - Other Linker Flag 에 -ObjC Flag 추가
        - Allow Non-Modular Includes In Framework Modules 를 Yes로 설정

## BidmadSDK Interface Guide

1. 배너 광고

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

2. 전면 광고

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

3. 보상형 비디오 광고

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

4. Offerwall 광고

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

        - 배너 광고 초기화 함수

        — (void)requestBannerView;

        - 배너 광고 요청 함수

        — (void)removeAds;

        - 배너 광고 삭제 함수

        @property (nonatomic) bannerSizeType bannerType;

        - 배너광고 사이즈 타입
        - banner_320_50
        - banner_300_250

        @property (nonatomic, strong) NSString* zoneID;

        - 배너 ZoneId
    2. BIDMADBannerDelegate

        — (void)BIDMADBannerAllFail:(BIDMADBanner *)core;

        - 배너 광고 에러 시, 호출

        — (void)BIDMADBannerLoad:(BIDMADBanner *)core;

        - 배너 광고 나올 시, 호출

        — (void)BIDMADBannerClick:(BIDMADBanner*) core;

        - 배너 광고 클릭 시, 호출
    3. BIDMADInterstitial

        — (id)init;

        - 전면 광고 초기화 함수

        — (void)loadInterstitialView;

        - 전면 광고 요청 함수

        — (void)showInterstitialView;

        - 요청된 전면 광고 보여주는 함수

        @property (nonatomic, strong) UIViewController* parentViewController;

        - 유저 뷰 컨트롤러 설정 프로퍼티

        @property (nonatomic, strong) NSString* zoneID;

        - 전면 ZONE ID
    4. BIDMADInterstitialDelegate

        — (void)BIDMADInterstitialAllFail:(BIDMADInterstitial *)core;

        - 전면 광고 에러 시, 호출

        — (void)BIDMADInterstitialLoad:(BIDMADInterstitial *)core;

        - 전면 광고 요청 완료 될 시, 호출

        — (void)BIDMADInterstitialClose:(BIDMADInterstitial *)core;

        - 전면 광고 보여줄 시, 호출

        — (void)BIDMADInterstitialShow:(BIDMADInterstitial *)core;

        - 전면 광고 닫힐 시, 호출
    5. BIDMADReward

        — (id)init;

        - 보상형 광고 초기화 함수

        — (void)loadRewardVideo;

        - 보상형 광고 요청 함수

        — (void)showRewardVideo;

        - 요청된 보상형 광고 보여주는 함수

        @property (nonatomic, strong) UIViewController* parentViewController;

        - 유저 뷰 컨트롤러 설정 프로퍼티

        @property (nonatomic, strong) NSString* zoneID;

        - 보상형 ZONE ID
    6. BIDMADRewardVideoDelegate

        — (void)BIDMADRewardVideoAllFail:(BIDMADRewardVideo *)core;

        - 보상 광고 에러 시, 호출

        — (void)BIDMADRewardVideoLoad:(BIDMADRewardVideo *)core;

        - 보상 광고 요청 후, 광고가 성공적으로 로드됐을 경우,호출

        — (void)BIDMADRewardVideoShow:(BIDMADRewardVideo *)core;

        - 보상 광고 보여줄 시, 호출

        — (void)BIDMADRewardVideoClose:(BIDMADRewardVideo *)core;

        - 보상 광고 닫힐 시, 호출

        — (void)BIDMADRewardVideoSucceed:(BIDMADRewardVideo *)core;

        - 보상 완료되었을 경우, 호출

        — (void)BIDMADRewardSkipped:(BIDMADRewardVideo *) core;

        - 보상 조건을 만족하지 않은 경우, 호출
    7. BIDMADOfferwall

        — (id)initWithZoneId:(NSString *)zoneId;

        - Offerwall 광고 초기화 함수

        + (BOOL)isSDKInit;

        - Offerwall 광고 초기화 여부 확인 함수

        — (void)loadOfferwall;

        - Offerwall 광고 요청 함수

        — (void)showOfferwall;

        - 요청된 Offerwall 광고 보여주는 함수

        — (void)getCurrencyBalance;

        - 지급된 Offerwall 재화 확인함수

        — (void)spendCurrency:(int)amount;

        - Offerwall 재화 소모 함수

        @property (nonatomic, strong) UIViewController* parentViewController;

        - 유저 뷰 컨트롤러 설정 프로퍼티

        @property (nonatomic, strong) NSString* zoneID;

        - Offerwall ZONE ID
    8. BIDMADOfferwallDelegate

        — (void)BIDMADOfferwallInitSuccess:(BIDMADOfferwall *)core;

        - Offerwall 광고 SDK 초기화 성공 시, 호출

        — (void)BIDMADOfferwallInitFail:(BIDMADOfferwall *)core error:(NSString *)error;

        - Offerwall 광고 SDK 초기화 실패 시, 호출

        — (void)BIDMADOfferwallLoadAd:(BIDMADOfferwall *)core;

        - Offerwall 광고 로드 성공 시, 호출

        — (void)BIDMADOfferwallShowAd:(BIDMADOfferwall *)core;

        - 로드한 Offerwall 광고를 Show 했을 시, 호출

        — (void)BIDMADOfferwallFailedAd:(BIDMADOfferwall *)core;

        - Offerwall 광고 로드 실패 시, 호출

        — (void)BIDMADOfferwallCloseAd:(BIDMADOfferwall *)core;

        - Offerwall 광고를 닫을 시, 호출

        — (void)BIDMADOfferwallGetCurrencyBalanceSuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance;

        - 지급된 Offerwall 광고 재화 조회 성공 시, 호출

        — (void)BIDMADOfferwallGetCurrencyBalanceFail:(BIDMADOfferwall *)core error:(NSString *)error;

        - 지급된 Offerwall 광고 재화 조회 실패 시, 호출

        — (void)BIDMADOfferwallSpendCurrencySuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance;

        - 지급된 Offerwall 광고 재화 소모 성공 시, 호출

        — (void)BIDMADOfferwallSpendCurrencyFail:(BIDMADOfferwall *)core error:(NSString *)error;

        - 지급된 Offerwall 광고 재화 소모 실패 시, 호출
6. 유의 사항
    1. 배너 광고와 전면 광고 구현 할 시, Delegate(광고의 상태를 자동으로 호출)를 구현 하여 광고 상태를 참조 할 것.
    2. 배너 광고 최소 요청 주기 10초이상.
    3. BIDMADSetting의 초기 설정값
        - age = 20;
        - gender = “ ”;
        - keyword = “ ”;
        - longtitude = 0;
        - latitude = 0;
        - refreshInterval = 60;
7. 기타
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
        - ARPM 추가
    2. 2020.02.18
        - Admob mediation 추가
    3. 2020.05.13
        - MoPub 추가
    4. 4. 2020.05.18
        - 네트워크리스트 수정 편집
    5. 2020.05.25
        - 테스트 디바이스 추가
    6. 2020.09.09
        - IronSource 추가
        - 국가별 미디에이션 기능 추가
    7. 2020.09.15
        - BIDMADBanner 인터페이스 변경
    8. 2020.09.22
        - iOS 14.0 대비 SDK 최신화작업
    9. 2020.11.09
        - AdFit, UnityAds, AdColony 배너추가
    10. 2020.11.23
        - 최소 iOS 버전 11.0으로 상향
    11. 2021.02.16
        - BidmadSetting에서 지원하는 일부 인터페이스 Deprecate
        - Offerwall 광고 타입 지원
    12. 2021.05.12
        - BidmadSDK CocoaPods 지원
