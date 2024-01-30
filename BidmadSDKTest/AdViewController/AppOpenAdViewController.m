//
//  AppOpenAdViewController.m
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/06.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import "AppOpenAdViewController.h"
#import <ADOPUtility/ADOPLog.h>
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
    
    self->appOpenAd = [[BidmadAppOpenAd alloc] initWithZoneID:@"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
    [self->appOpenAd setDelegate: self];
    
    // Bidmad AppOpenAd Ads can be set with Custom Unique ID with the following method.
    [BidmadCommon setCuid:@"YOUR ENCRYPTED ID"];
}

- (IBAction)buttonPressAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Load"]) {
        [self->appOpenAd load];
    } else if ([sender.titleLabel.text isEqualToString:@"Show"]) {
        if ([self->appOpenAd isLoaded]) {
            [self->appOpenAd showOnViewController:self];
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

- (void)onLoadAd:(OpenBiddingAppOpenAd *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App AppOpenAd Load");
    [self.callbackLabel setText:@"Load"];
}

- (void)onShowAd:(OpenBiddingAppOpenAd *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App AppOpenAd Show");
    [self.callbackLabel setText:@"Show"];
}

- (void)onClickAd:(OpenBiddingAppOpenAd *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App AppOpenAd Click");
    [self.callbackLabel setText:@"Click"];
}

- (void)onCloseAd:(OpenBiddingAppOpenAd *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App AppOpenAd Close");
    [self.callbackLabel setText:@"Close"];
}

- (void)onLoadFailAd:(OpenBiddingAppOpenAd *)bidmadAd error:(NSError *)error {
    ADOPLog.printInfo(@"Bidmad Sample App AppOpenAd All Fail");
    [self.callbackLabel setText:@"All Fail"];
}

- (void)onShowFailAd:(OpenBiddingAppOpenAd *)bidmadAd error:(NSError *)error {
    ADOPLog.printInfo(@"Bidmad Sample App AppOpenAd Show Fail");
    [self.callbackLabel setText:@"Show Fail"];
}

@end
