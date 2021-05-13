# OpenBiddingHelper iOS
## A Wrapper Framework for Google AdMob Open Bidding

1. 개요
    - OpenBiddingHelper는 Open Bidding by Google AdMob 만을 위해 사용되어야 합니다.
    - OpenBiddingHelper 사용 시, ADOP 담당부서에 연락 주시면 감사하겠습니다.  

## OpenBiddingHelper Installation Guide

1. 개발 환경
    - Xcode 12.0
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. Helper 설치 방법
    - **(추천)** CocoaPods를 사용한 설치 방법

        1. Podfile 내부에 다음 코드 추가

        ```
        platform :ios, "10.0"

        target "Runner" do
         use_frameworks!
         pod "OpenBiddingHelper", "1.2.1"
        ```

        2. 터미널에 다음 명령을 내려주십시오

        ```
        pod install
        ```

    - **(비추천)** 수동적인 Framework 추가 방법
        1. 프레임워크 및 번들을 아래 첨부 그림과 같이 프로젝트에 추가

            ![BidmadSDK%20Interface%20Guide%200fab5e4337eb4ee291be98969dbc7a78/Screenshot_of_Xcode_(2021-05-12_3-10-19_PM).png](https://drive.google.com/uc?export=view&id=1t63jauRPErG2Nf5MUM_mcf1KFpp4ecC_)

        2. Embedded Binaries에 OpenBiddingHelper.framework 추가   
        3. Build Phases 탭 아래 있는 Copy Bundle Resources에 "bidmad_asset.bundle" 추가
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

## OpenBiddingHelper Interface Guide

### 배너 광고 로드

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@interface BannerViewController : UIViewController<BIDMADOpenBiddingBannerDelegate>
...
@end
@implementation BannerViewController

- (void)viewDidLoad {
    ...
    // "bannerSize"는 "banner_320_50" 고정값만 전달해주십시오
    banner = [[OpenBiddingBanner alloc] initWithParentViewController:self rootView:self.BannerContainer bannerSize:banner_320_50];
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

### 배너 콜백 구현

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADOpenBiddingAllFail:(OpenBiddingBanner *)core {
    NSLog(@"BIDMADOpenBiddingAllFail");
}

- (void)BIDMADOpenBiddingBannerClosed:(OpenBiddingBanner *)core {
    NSLog(@"BIDMADOpenBiddingBannerClosed");
}

-(void)BIDMADOpenBiddingBannerLoad:(OpenBiddingBanner *)core {
    NSLog(@"BIDMADOpenBiddingBannerLoad");
}
```
</details>

### 전면 광고 로드

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@interface InterstitialViewController : UIViewController<BIDMADOpenBiddingInterstitialDelegate>
...
@end
...
@implementation InterstitialViewController
- (void)viewDidLoad {
    ...
    interstitial = [[OpenBiddingInterstitial alloc] init];
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

### 전면 광고 콜백 구현

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADOpenBiddingInterstitialClose:(OpenBiddingInterstitial *)core {
    NSLog(@"BIDMADOpenBiddingInterstitialClose");
}

- (void)BIDMADOpenBiddingInterstitialShow:(OpenBiddingInterstitial *)core {
    NSLog(@"BIDMADOpenBiddingInterstitialShow");
}

-(void)BIDMADOpenBiddingInterstitialLoad:(OpenBiddingInterstitial *)core {
    NSLog(@"BIDMADOpenBiddingInterstitialLoad");
}
- (void)BIDMADOpenBiddingInterstitialAllFail:(OpenBiddingInterstitial *)core {
    NSLog(@"BIDMADOpenBiddingInterstitialAllFail");
}
```
</details>

### 보상형 비디오 광고 로드

<details markdown="1">
<summary>ObjC</summary>
<br>

```
@interface RewardViewController : UIViewController<BIDMADOpenBiddingRewardVideoDelegate>
...
@end
...
@implementation RewardViewController

- (void)viewDidLoad {
    ...
    reward = [[OpenBiddingRewardVideo alloc]init];
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

### 보상형 비디오 콜백 구현

<details markdown="1">
<summary>ObjC</summary>
<br>

```
- (void)BIDMADOpenBiddingRewardVideoLoad:(OpenBiddingRewardVideo *)core {
    NSLog(@"BIDMADOpenBiddingRewardVideoLoad");
}

- (void)BIDMADOpenBiddingRewardVideoAllFail:(OpenBiddingRewardVideo *)core {
    NSLog(@"BIDMADOpenBiddingRewardVideoAllFail");
}

- (void)BIDMADOpenBiddingRewardVideoShow:(OpenBiddingRewardVideo *)core {
    NSLog(@"BIDMADOpenBiddingRewardVideoShow");
}

- (void)BIDMADOpenBiddingRewardVideoClose:(OpenBiddingRewardVideo *)core {
    NSLog(@"BIDMADOpenBiddingRewardVideoClose");
}

- (void)BIDMADOpenBiddingRewardVideoSucceed:(OpenBiddingRewardVideo *)core {
    NSLog(@"BIDMADOpenBiddingRewardVideoSucceed");
}
```
</details>
