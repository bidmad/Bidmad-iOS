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
