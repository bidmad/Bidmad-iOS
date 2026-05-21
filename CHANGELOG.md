#### Version 7.0.0 (Breaking Changes)
iOS 최소 지원 버전 상향 및 광고 네트워크 SDK 대규모 업데이트. <7.0.0 에서 마이그레이션 시 다음 사항을 확인하십시오. BidmadSDK / OpenBiddingHelper / 어댑터의 공개 API는 변경되지 않았지만 빌드 환경과 의존 SDK 버전이 변경되었으므로 앱 측 설정 점검이 필요합니다.

- **빌드 환경**
  - iOS Deployment Target: **13.0 → 14.0** (Podfile / Xcode 프로젝트 모두 14.0 이상으로 상향 필요)
  - 어댑터 podspec 세대 (suffix): `.13.0` → **`.14.0`** (iOS 14 floor)
- **신규 광고 네트워크 어댑터**
  - `BidmadAppLovinMAXAdapter` 신규 pod 추가 — AppLovin MAX 미디에이션 사용 시 `BidmadAppLovinAdapter`와 별개로 의존성을 추가
- **제거된 어댑터**
  - `BidmadPubmaticAdapter`, `BidmadTargetPickAdapter` 더 이상 빌드되지 않음 (Podfile 에서 제거 필요)
- **광고 네트워크 SDK 버전 업데이트**
  - Google Mobile Ads SDK: 12.6.0 → **13.2.0** (AdMob / Ad Manager 어댑터)
  - AppLovinSDK: 13.3.1 → **13.6.2** (AppLovin / AppLovin MAX 어댑터)
  - Pangle (Ads-Global): 7.2.0.5 → **7.9.0.8**
  - VungleAds: 7.5.1 → **7.7.2**
  - TeadsSDK: 5.2.0 → **6.1.0** (메이저 업그레이드)
  - AdFitSDK: 3.12.7 → **3.18.3**
  - UnityAds: 4.15.0 → **4.17.0**
  - Fyber Marketplace SDK: 8.3.7 → **8.4.6**
  - TaboolaSDK: 3.8.33 → **3.9.12**
  - AdPieSDK: 1.6.1 → **1.6.16**
  - AdMixer: 1.0.8 → **1.1.6** (AdMixerMediation 2.0.2 → 2.3.2)
  - GoogleUserMessagingPlatform: 3.0.0 → **3.1.0**
- **마이그레이션 가이드**
  - Podfile 의 `platform :ios, "13.0"` 을 `"14.0"` 으로 변경하고 `post_install`의 `IPHONEOS_DEPLOYMENT_TARGET` 도 14.0 으로 갱신
  - 모든 `Bidmad*` 의존성 버전을 본 저장소 Podfile/README 의 7.0.0 예시 그대로 갱신
  - `pod repo update && pod install` 실행

`<6.14.0` 에서 7.0.0 으로 한 번에 마이그레이션하는 경우, 6.14.0 의 델리게이트 API 변경 사항도 함께 적용해야 합니다(아래 6.14.0 항목 참고).

#### Version 6.14.0 (Breaking Changes)
Banner / AppOpen / NativeAd 델리게이트 인터페이스 정리. <6.14.0 에서 마이그레이션 시 다음 변경사항을 반드시 적용해야 합니다. 광고 클래스(`BidmadBannerAd`, `BidmadAppOpenAd`, `BidmadNativeAd`) 자체는 동일하며, 델리게이트 프로토콜과 콜백 메서드 시그니처만 변경되었습니다.

- **Banner**
  - 델리게이트 프로토콜: `BIDMADOpenBiddingBannerDelegate` 제거 → `BidmadBannerAdDelegate` 사용
  - 콜백 메서드 (파라미터 타입도 `OpenBiddingBanner *` → `BidmadBannerAd *` 으로 변경):
    - `onLoadAd:info:` → `onLoadBannerAd:info:` (Swift: `onLoad(bannerAd:info:)`)
    - `onClickAd:info:` → `onClickBannerAd:info:` (Swift: `onClick(bannerAd:info:)`)
    - `onLoadFailAd:error:` → `onLoadFailBannerAd:error:` (Swift: `onLoadFail(bannerAd:error:)`)
- **AppOpen**
  - 델리게이트 프로토콜: `OpenBiddingAppOpenAdDelegate` 제거 → `BidmadAppOpenAdDelegate` 사용
  - 콜백 메서드 (파라미터 타입도 `OpenBiddingAppOpenAd *` → `BidmadAppOpenAd *` 으로 변경):
    - `onLoadAd:info:` → `onLoadAppOpenAd:info:` (Swift: `onLoad(appOpenAd:info:)`)
    - `onLoadFailAd:error:` → `onLoadFailAppOpenAd:error:` (Swift: `onLoadFail(appOpenAd:error:)`)
    - `onShowAd:info:` → `onShowAppOpenAd:info:` (Swift: `onShow(appOpenAd:info:)`)
    - `onShowFailAd:info:error:` → `onShowFailAppOpenAd:info:error:` (Swift: `onShowFail(appOpenAd:info:error:)`)
    - `onClickAd:info:` → `onClickAppOpenAd:info:` (Swift: `onClick(appOpenAd:info:)`)
    - `onCloseAd:info:` → `onCloseAppOpenAd:info:` (Swift: `onClose(appOpenAd:info:)`)
  - `BidmadAppOpenAd`의 `deregisterForAppOpenAd` 메서드 제거 (자동 표시 비활성화 로직이 단순화됨)
- **NativeAd**
  - 콜백 메서드:
    - `onLoadAd:info:` → `onLoadNativeAd:info:` (Swift: `onLoad(nativeAd:info:)`)
    - `onClickAd:info:` → `onClickNativeAd:info:` (Swift: `onClick(nativeAd:info:)`)
    - `onLoadFailAd:error:` → `onLoadFailNativeAd:error:` (Swift: `onLoadFail(nativeAd:error:)`)

Interstitial / Reward 인터페이스는 변경되지 않았습니다.

#### Version 6.12.4
BidmadSDK supports GoogleMobileAds v12.6.0 with other ad networks

#### Version 6.12.0
BidmadSDK supports Taboola, Mobwith Ad Networks.

#### Version 6.6.1
BidmadSDK supports PrivacyManifest file
IronSource banner mispositioning bug fixed 

#### Version 6.6.0
BidmadSDK and OpenBiddingHelper now support Show-Fail callback
AppOpenAd Type initializer method no longer requires View Controller

#### Version 6.5.0
BidmadSDK does not rely on AdMob libraries
Bug fixes

<details>
<summary>Check Available Support libraries</summary>
<div markdown="1">
<li>AdMob Adapter - 10.12.0.1</li>
<li>AdManager Adapter - 10.12.0.1</li>
<li>AdColony Adapter - 4.9.0.1</li>
<li>AppLovin Adapter - 11.11.3.1</li>
<li>ADOP Adapter - 1.0.0.1</li>
<li>Coupang Adapter - 1.0.0.1</li>
<li>Fyber Adapter - 8.2.4.1</li>
<li>IronSource Adapter - 7.5.0.0.1</li>
<li>Pangle Adapter - 5.3.1.0.1</li>
<li>PubMatic Adapter - 3.2.0.1</li>
<li>Teads Adapter - 5.0.27.1</li>
<li>UnityAds Adapter - 4.8.0.1</li>
<li>Vungle Adapter - 7.1.0.1</li>
</div>
</details>

#### Version 6.4.1
DAU collection bug fixed

#### Version 6.4.0
Apply adapters classified by ad network

#### Version 6.3.1
Add Coupang network

#### Version 6.2.0
Eliminate unnecessary networks

#### Version 6.1.0
bug fix

#### Version 6.0.0
Improved native advertising interface

#### Version 5.3.0
Updates to BIDMAD banner and settings

#### Version 5.2.0
Native ad performance improvements and interface changes

#### Version 5.1.1
Native ad mediation bug fix

#### Version 5.1.0
Added network support

#### Version 5.0.0
Improved front/reward interface
