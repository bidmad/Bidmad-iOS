#import "OfferwallController.h"

@implementation OfferwallController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"AppUI isSDKInit %d", [BIDMADOfferwall isSDKInit]);
    
    [[BIDMADSetting sharedInstance]setIsDebug:YES];
    self.offerwall = [[BIDMADOfferwall alloc]initWithZoneId:@"5ede71e1-07b4-4987-9bc0-e8a3c62e6548"];
    [self.offerwall setParentViewController:self];
    [self.offerwall setDelegate:self];
}

-(IBAction)loadOfferwall:(UIButton*)sender{
    [self.offerwall loadOfferwall];
   
}

-(IBAction)showOfferwall:(UIButton*)sender{
    [self.offerwall showOfferwall];
}

-(IBAction)getCurrncy:(UIButton*)sender{
    [self.offerwall getCurrencyBalance];
   
}

-(IBAction)spendCurrncy:(UIButton*)sender{
    NSString* inputAmount = self.inputSpendCurrency.text;
    [self.offerwall spendCurrency:[inputAmount intValue]];
}

-(void)renewBalance:(int)amount{
    self.textCurrency.text = [NSString stringWithFormat:@"%d",amount];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark Offerwall Delegate
- (void)BIDMADOfferwallInitSuccess:(BIDMADOfferwall *)core
{
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallInitSuccess";
}
- (void)BIDMADOfferwallInitFail:(BIDMADOfferwall *)core error:(NSString *)error
{
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallInitFail";
}
- (void)BIDMADOfferwallLoadAd:(BIDMADOfferwall *)core
{
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallLoadAd";
}
- (void)BIDMADOfferwallShowAd:(BIDMADOfferwall *)core
{
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallShowAd";
}
- (void)BIDMADOfferwallFailedAd:(BIDMADOfferwall *)core
{
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallFailedAd";
}
- (void)BIDMADOfferwallCloseAd:(BIDMADOfferwall *)core
{
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallCloseAd";
}

- (void)BIDMADOfferwallGetCurrencyBalanceSuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance
{
    NSLog(@"BIDMADOfferwallGetCurrencyBalanceSuccess %@, %d", currencyName, balance);
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallGetCurrencyBalanceSuccess";
    [self renewBalance:balance];
}
- (void)BIDMADOfferwallGetCurrencyBalanceFail:(BIDMADOfferwall *)core error:(NSString *)error
{
    NSLog(@"BIDMADOfferwallGetCurrencyBalanceFail %@", error);
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallGetCurrencyBalanceFail";
}
- (void)BIDMADOfferwallSpendCurrencySuccess:(BIDMADOfferwall *)core currencyName:(NSString *)currencyName balance:(int)balance
{
    NSLog(@"BIDMADOfferwallSpendCurrencySuccess %@, %d", currencyName, balance);
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallSpendCurrencySuccess";
}
- (void)BIDMADOfferwallSpendCurrencyFail:(BIDMADOfferwall *)core error:(NSString *)error
{
    NSLog(@"BIDMADOfferwallSpendCurrencyFail %@", error);
    self.offerwallCallbackDisplay.text = @"BIDMADOfferwallSpendCurrencyFail";
}

@end
