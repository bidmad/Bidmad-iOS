//
//  AppOpenAdViewController.m
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/06.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import "AppOpenAdViewController.h"
@import OpenBiddingHelper;

@interface AppOpenAdViewController () <OpenBiddingAppOpenAdDelegate> {
    BidmadAppOpenAd *appOpenAd;
}
@property (weak, nonatomic) IBOutlet UILabel *callbackLabel;
@end

@implementation AppOpenAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.callbackLabel setText:@"No Callback Yet"];
    
    [[BIDMADSetting sharedInstance] setIsDebug:YES];
    
    self->appOpenAd = [[BidmadAppOpenAd alloc] initWith:self zoneID:@"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
    [self->appOpenAd setDelegate: self];
    
    // Bidmad AppOpenAd Ads can be set with Custom Unique ID with the following method.
    [self->appOpenAd setCUID:@"YOUR ENCRYPTED ID"];
    [self->appOpenAd setCUID:@""];
}

- (IBAction)buttonPressAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Load"]) {
        [self->appOpenAd load];
    } else if ([sender.titleLabel.text isEqualToString:@"Show"]) {
        if ([self->appOpenAd isLoaded]) {
            [self->appOpenAd show];
        }
    } else if ([sender.titleLabel.text isEqualToString:@"Deregister"]) {
        if (self->appOpenAd != nil) {
            [self->appOpenAd deregisterForAppOpenAd];
        }
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark AppOpenAd Delegate Methods

- (void)OpenBiddingAppOpenAdLoad:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Bidmad Sample App AppOpenAd Load");
    [self.callbackLabel setText:@"Load"];
}

- (void)OpenBiddingAppOpenAdShow:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Bidmad Sample App AppOpenAd Show");
    [self.callbackLabel setText:@"Show"];
}

- (void)OpenBiddingAppOpenAdClick:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Bidmad Sample App AppOpenAd Click");
    [self.callbackLabel setText:@"Click"];
}

- (void)OpenBiddingAppOpenAdClose:(OpenBiddingAppOpenAd *)core {
    NSLog(@"Bidmad Sample App AppOpenAd Close");
    [self.callbackLabel setText:@"Close"];
}

- (void)OpenBiddingAppOpenAdAllFail:(OpenBiddingAppOpenAd *)core code:(NSString *)error {
    NSLog(@"Bidmad Sample App AppOpenAd All Fail");
    [self.callbackLabel setText:@"All Fail"];
}

@end
