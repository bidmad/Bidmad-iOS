# OpenBiddingHelper iOS
## A Wrapper Framework for Google AdMob Open Bidding

1. Introduction
    - OpenBiddingHelper should only be used for Open Bidding by Google AdMob
    - Please contact ADOP App Monetization team if you wish to use Google Open Bidding and OpenBiddingHelper. 

## OpenBiddingHelper Installation Guide

1. Development Environment
    - Xcode 12.0
    - BASE SDK : iOS
    - iOS Deployment Target : 11.0
2. Helper Installation Methods
    - **(Highly Recommended)** Installation through CocoaPods

        Add the following code in your project Podfile.

        ```
        platform :ios, "10.0"

        target "Runner" do
         use_frameworks!
         pod "OpenBiddingHelper", "1.2.1"
        ```

        Followed by entering the following command in Terminal.

        ```
        pod install
        ```

    - **(Not Recommeded)** Manual Framework Embedding Method
        1. Please add the framework and bundle into your project, just as the image below.

            ![BidmadSDK%20Interface%20Guide%200fab5e4337eb4ee291be98969dbc7a78/Screenshot_of_Xcode_(2021-05-12_3-10-19_PM).png](https://drive.google.com/uc?export=view&id=1t63jauRPErG2Nf5MUM_mcf1KFpp4ecC_)

        2. Add OpenBiddingHelper.framework to Embedded Binaries  
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

## OpenBiddingHelper Interface Guide

### Banner Ad Load

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

### Banner Callback Implementations

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

### Interstitial Ad Load

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

### Interstitial Callback Implementations

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

### Reward Ad Load

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

### Reward Callback Implementations

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
