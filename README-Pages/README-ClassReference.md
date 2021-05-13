## Class Reference for BidmadSDK-iOS

### BIDMADBanner
- Banner Ad Class

|Function|Description|
|---|---|
|(id)initWithParentViewController:(UIViewController *)parentVC rootView:(UIView *)view bannerSize:(bannerSizeType) bannerTypeParam;|Banner Ad Initialization Method|
| (void)requestBannerView;|Banner Ad Request Method| 
| (void)removeAds;|Banner Ad Removal Method|
| @ property  (nonatomic, strong) NSString* zoneID;|Banner Ad ZoneId|

### BIDMADBannerDelegate
- Banner Ad Callback

|Function|Description|
|---|---|
|(void)BIDMADBannerAllFail:(BIDMADBanner *)core;|If error, the method gets called |
|(void)BIDMADBannerLoad:(BIDMADBanner *)core;|If loaded, the method gets called|
| (void)BIDMADBannerClick:(BIDMADBanner*) core;|If clicked, the method gets called|

###  BIDMADInterstitial
-  Interstitial Ad Class 

|Function|Description|
|---|---|
|(id)init;|Intersetitial Ad Initialization Method|
|(void)loadInterstitialView;|Interstitial Ad Request and load method| 
|(void)showInterstitialView;|Show the interstitial Ad|
| @property (nonatomic, strong) UIViewController* parentViewController;|UIViewController property for viewing ads|
| @ property  (nonatomic, strong) NSString* zoneID;|Interstitial Ad ZoneId|

###  BIDMADInterstitialDelegate
-  Interstitial Callbacks 

|Function|Description|
|---|---|
|(void)BIDMADInterstitialAllFail:(BIDMADInterstitial *)core;|If error, the method gets called|
|(void)BIDMADInterstitialLoad:(BIDMADInterstitial *)core;|If request and loading are done, the method gets called| 
|(void)BIDMADInterstitialClose:(BIDMADInterstitial *)core;|When the ad is closed, the method gets called|
|(void)BIDMADInterstitialShow:(BIDMADInterstitial *)core;|When showing the interstitial ad, the method gets called |


###  BIDMADReward
- Reward Ad Class 

|Function|Description|
|---|---|
|(id)init;|Initialization method|
|(void)loadRewardVideo;|Reward Ad Request method| 
|(void)showRewardVideo;|Requested reward ad show method|
|@property (nonatomic, strong) UIViewController* parentViewController;|UIViewController Settings Property|
|@property (nonatomic, strong) NSString* zoneID;Reward Video ZONE ID|

###  BIDMADRewardVideoDelegate
-  Reward Callbacks 

|Function|Description|
|---|---|
|(void)BIDMADRewardVideoAllFail:(BIDMADRewardVideo *)core;|Called when reward ad error|
|(void)BIDMADRewardVideoLoad:(BIDMADRewardVideo *)core;|Called if the ad is loaded successfully after requesting a reward ad| 
|(void)BIDMADRewardVideoShow:(BIDMADRewardVideo *)core;|Called when reward ad is closed|
|(void)BIDMADRewardVideoClose:(BIDMADRewardVideo *)core;|UIViewController Settings Property|
|(void)BIDMADRewardVideoSucceed:(BIDMADRewardVideo *)core;|Called when the user completed watching the reward video |
|(void)BIDMADRewardSkipped:(BIDMADRewardVideo *) core;|Called if reward conditions are not met|

###  BIDMADOfferwall
- Offerwall Ad Class 

|Function|Description|
|---|---|
|(id)initWithZoneId:(NSString *)zoneId;|Offerwall Initialization|
|(BOOL)isSDKInit;|Checks if the SDK for Offerwall was initialized| 
|(void)loadOfferwall;|Offerwall Ad Request and Load method|
|(void)showOfferwall;|Show the loaded ad|
|(void)getCurrencyBalance;|Call the Offerwall SDK to check the current currency balance|
|(void)spendCurrency:(int)amount;|Offerwall Currency Consumption method|
|@property (nonatomic, strong) UIViewController* parentViewController;|UIViewController Setting Property|
|@property (nonatomic, strong) NSString* zoneID;|Offerwall ZONE ID|

###  BIDMADOfferwallDelegate
-  Offerwall Callbacks 

|Function|Description|
|---|---|
|(void)BIDMADOfferwallInitSuccess:(BIDMADOfferwall *)core;|Called when successfully initialized Offerwall Ad SDK|
|(void)BIDMADOfferwallInitFail:(BIDMADOfferwall *)core error:(NSString *)error;|Called when the Offerwall Ad SDK fails to be initialized|
|(void)BIDMADOfferwallLoadAd:(BIDMADOfferwall *)core;|Called when Offerwall ads are loaded successfully|
|(void)BIDMADOfferwallShowAd:(BIDMADOfferwall *)core;|Called when Offerwall ad is shown|
|(void)BIDMADOfferwallFailedAd:(BIDMADOfferwall *)core;|Called when Offerwall ad load fails|
|(void)BIDMADOfferwallCloseAd:(BIDMADOfferwall *)core;|Called when closing an Offerwall ad|
|(void)BIDMADOfferwallGetCurrencyBalanceSuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance;|Called when Offerwall advertising currency is loaded successfully |
|(void)BIDMADOfferwallGetCurrencyBalanceFail:(BIDMADOfferwall *)core error:(NSString *)error;|Called when Offerwall advertising currency is loaded unsuccessfully|
|(void)BIDMADOfferwallSpendCurrencySuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance;|Called when the currency was consumed successfully |
|(void)BIDMADOfferwallSpendCurrencyFail:(BIDMADOfferwall *)core error:(NSString *)error;|Called when spending the currency was failed|
|@property (nonatomic, strong) UIViewController* parentViewController;|Called when successfully initialized Offerwall Ad SDK|
|@property (nonatomic, strong) UIViewController* parentViewController;|Called when the Offerwall Ad SDK fails to be initialized|
