#import "OfferwallController.h"
@import OpenBiddingHelper;
@import BidmadAdapterFNC;

@interface OfferwallController() <BIDMADOfferwallDelegate> {
    BidmadOfferwallAd *offerwallAd;
}

@end

@implementation OfferwallController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[BIDMADSetting sharedInstance]setIsDebug:YES];
    self->offerwallAd = [[BidmadOfferwallAd alloc] initWith:self zoneID:@"5ede71e1-07b4-4987-9bc0-e8a3c62e6548"];
    [self->offerwallAd setDelegate: self];
    
    // Bidmad Offerwall Ads can be set with Custom Unique ID with the following method.
    [self->offerwallAd setCUID:@"YOUR ENCRYPTED ID"];
}

-(IBAction)loadOfferwall:(UIButton*)sender{
    [self->offerwallAd load];
   
}

-(IBAction)showOfferwall:(UIButton*)sender{
    [self->offerwallAd show];
}

-(IBAction)getCurrncy:(UIButton*)sender{
    [self->offerwallAd getCurrencyWithCurrencyReceivalCompletion:^(BOOL isSuccess, NSInteger currencyAmount) {
        if (!isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Currency Receival Failed");
                [self.offerwallCallbackDisplay setText:@"Currency Receival Failed"];
            });
            return;
        }
        
        NSLog(@"Currency Receival Success");
        [self.offerwallCallbackDisplay setText:@"Currency Receival Success"];
        [self.textCurrency setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:currencyAmount]]];
    }];
   
}

-(IBAction)spendCurrncy:(UIButton*)sender{
    NSString* inputAmount = self.inputSpendCurrency.text;
    [self->offerwallAd spendCurrency:[inputAmount integerValue] currencySpenditureCompletion:^(BOOL isSuccess, NSInteger currencyAmount) {
        if (!isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Currency Spenditure Failed");
                [self.offerwallCallbackDisplay setText:@"Currency Spenditure Failed"];
            });
        }
        
        NSLog(@"Currency Spenditure Success");
        [self.offerwallCallbackDisplay setText:@"Currency Spenditure Success"];
        [self.textCurrency setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:currencyAmount]]];
    }];
}

-(void)renewBalance:(int)amount{
    self.textCurrency.text = [NSString stringWithFormat:@"%d",amount];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark Offerwall Delegate
- (void)BIDMADOfferwallLoadAd:(BIDMADOfferwall *)core {
    NSLog(@"Bidmad Sample App Offerwall Load");
    [self.offerwallCallbackDisplay setText:@"Load"];
}

- (void)BIDMADOfferwallShowAd:(BIDMADOfferwall *)core {
    NSLog(@"Bidmad Sample App Offerwall Show");
    [self.offerwallCallbackDisplay setText:@"Show"];
    
    [self->offerwallAd load];
}

- (void)BIDMADOfferwallCloseAd:(BIDMADOfferwall *)core {
    NSLog(@"Bidmad Sample App Offerwall Close");
    [self.offerwallCallbackDisplay setText:@"Close"];
}

- (void)BIDMADOfferwallFailedAd:(BIDMADOfferwall *)core {
    NSLog(@"Bidmad Sample App Offerwall Failed");
    [self.offerwallCallbackDisplay setText:@"Fail"];
}

- (void)BIDMADOfferwallInitSuccess:(BIDMADOfferwall *)core {
    NSLog(@"Bidmad Sample App Offerwall Init Success");
    [self.offerwallCallbackDisplay setText:@"Init Success"];
}

- (void)BIDMADOfferwallInitFail:(BIDMADOfferwall *)core error:(NSString *)error {
    NSLog(@"Bidmad Sample App Offerwall Init Failed");
    [self.offerwallCallbackDisplay setText:@"Init Failed"];
}

@end
