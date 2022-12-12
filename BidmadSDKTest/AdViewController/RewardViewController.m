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

- (void)BIDMADOpenBiddingRewardSkipped:(OpenBiddingRewardVideo *)core {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Skipped");
    [[self rewardCallbackDisplay] setText:@"Skipped"];
}

- (void)BIDMADOpenBiddingRewardVideoLoad:(OpenBiddingRewardVideo *)core {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Load");
    [[self rewardCallbackDisplay] setText:@"Load"];
}

- (void)BIDMADOpenBiddingRewardVideoShow:(OpenBiddingRewardVideo *)core {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Show");
    [[self rewardCallbackDisplay] setText:@"Show"];
}

- (void)BIDMADOpenBiddingRewardVideoClick:(OpenBiddingRewardVideo *)core {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Click");
    [[self rewardCallbackDisplay] setText:@"Click"];
}

- (void)BIDMADOpenBiddingRewardVideoClose:(OpenBiddingRewardVideo *)core {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Close");
    [[self rewardCallbackDisplay] setText:@"Close"];
}

- (void)BIDMADOpenBiddingRewardVideoSucceed:(OpenBiddingRewardVideo *)core {
    ADOPLog.printInfo(@"Bidmad Sample App Reward Success");
    [[self rewardCallbackDisplay] setText:@"Success"];
}

- (void)BIDMADOpenBiddingRewardVideoAllFail:(OpenBiddingRewardVideo *)core {
    ADOPLog.printInfo(@"Bidmad Sample App Reward All Fail");
    [[self rewardCallbackDisplay] setText:@"All Fail"];
}

@end
