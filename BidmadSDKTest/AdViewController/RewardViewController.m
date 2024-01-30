//
//  RewardViewController.m
//  BidmadSDKTest
//  Created by hyjeon on 2019. 12. 25
//  Copyright © 2019년 전혜연. All rights reserved.
//

#import "RewardViewController.h"
#import <ADOPUtility/ADOPLog.h>
@import OpenBiddingHelper;

@interface RewardViewController () <BIDMADOpenBiddingRewardVideoDelegate> {
    BidmadRewardAd *rewardAd;
}
@end

@implementation RewardViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
    ADOPLog.printInfo(@" deviceId: %@", [BIDMADUtil identifierForAdvertising]);
    
    NSString *zoneID = @"29e1ef67-98d2-47b3-9fa2-9192327dd75d";
    rewardAd = [[BidmadRewardAd alloc] initWithZoneID:zoneID];
    rewardAd.delegate = self;
    
    // Bidmad Interstitial Ads can be set with Custom Unique ID with the following method.
    [BidmadCommon setCuid:@"YOUR ENCRYPTED ID"];
    
    // Auto Reload feature can be turned on and off with the following method
    [rewardAd setIsAutoReload:YES]; // Default is YES (Auto Reload turned ON)
}

-(IBAction)loadReward:(UIButton*)sender{
    [rewardAd load];
}

-(IBAction)showReward:(UIButton*)sender{
    [rewardAd showOnViewController:self];
}

- (IBAction)backBtnPressed:(id)sender {
    ADOPLog.printInfo(@"Back Button Pressed");
    
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark Reward Delegate

- (void)onSkipAd:(OpenBiddingRewardVideo *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Skipped");
    [[self rewardCallbackDisplay] setText:@"Skipped"];
}

- (void)onLoadAd:(OpenBiddingRewardVideo *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Load");
    [[self rewardCallbackDisplay] setText:@"Load"];
}

- (void)onShowAd:(OpenBiddingRewardVideo *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Show");
    [[self rewardCallbackDisplay] setText:@"Show"];
}

- (void)onClickAd:(OpenBiddingRewardVideo *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Click");
    [[self rewardCallbackDisplay] setText:@"Click"];
}

- (void)onCloseAd:(OpenBiddingRewardVideo *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Close");
    [[self rewardCallbackDisplay] setText:@"Close"];
}

- (void)onCompleteAd:(OpenBiddingRewardVideo *)bidmadAd {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Success");
    [[self rewardCallbackDisplay] setText:@"Success"];
}

- (void)onLoadFailAd:(OpenBiddingRewardVideo *)bidmadAd error:(NSError *)error {
    ADOPLog.printInfo(@"Bidmad Sample App Reward All Fail");
    [[self rewardCallbackDisplay] setText:@"All Fail"];
}

- (void)onShowFailAd:(OpenBiddingRewardVideo *)bidmadAd error:(NSError *)error {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Show Fail");
    [[self rewardCallbackDisplay] setText:@"Show Fail"];
}

@end
