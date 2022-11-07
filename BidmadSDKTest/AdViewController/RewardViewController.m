//
//  RewardViewController.m
//  BidmadSDKTest
//  Created by hyjeon on 2019. 12. 25
//  Copyright © 2019년 전혜연. All rights reserved.
//

#import "RewardViewController.h"
@import OpenBiddingHelper;

@interface RewardViewController () <BIDMADOpenBiddingRewardVideoDelegate> {
    BidmadRewardAd *rewardAd;
}
@end

@implementation RewardViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
    NSLog(@" deviceId: %@", [BIDMADUtil identifierForAdvertising]);
    
    NSString *zoneID = @"29e1ef67-98d2-47b3-9fa2-9192327dd75d";
    rewardAd = [[BidmadRewardAd alloc] initWith:self zoneID:zoneID];
    rewardAd.delegate = self;
    
    // Bidmad Rewarded Ads can be set with Custom Unique ID with the following method.
    [rewardAd setCUID:@"YOUR ENCRYPTED ID"];
    
    // Auto Reload feature can be turned on and off with the following method
    [rewardAd setIsAutoReload:YES]; // Default is YES (Auto Reload turned ON)
}

-(IBAction)loadReward:(UIButton*)sender{
    [rewardAd load];
}

-(IBAction)showReward:(UIButton*)sender{
    [rewardAd show];
}

- (IBAction)backBtnPressed:(id)sender {
    NSLog(@"Back Button Pressed");
    
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark Reward Delegate

- (void)BIDMADOpenBiddingRewardSkipped:(OpenBiddingRewardVideo *)core {
    NSLog(@"Bidmad Sample App Reward Skipped");
    [[self rewardCallbackDisplay] setText:@"Skipped"];
}

- (void)BIDMADOpenBiddingRewardVideoLoad:(OpenBiddingRewardVideo *)core {
    NSLog(@"Bidmad Sample App Reward Load");
    [[self rewardCallbackDisplay] setText:@"Load"];
}

- (void)BIDMADOpenBiddingRewardVideoShow:(OpenBiddingRewardVideo *)core {
    NSLog(@"Bidmad Sample App Reward Show");
    [[self rewardCallbackDisplay] setText:@"Show"];
}

- (void)BIDMADOpenBiddingRewardVideoClick:(OpenBiddingRewardVideo *)core {
    NSLog(@"Bidmad Sample App Reward Click");
    [[self rewardCallbackDisplay] setText:@"Click"];
}

- (void)BIDMADOpenBiddingRewardVideoClose:(OpenBiddingRewardVideo *)core {
    NSLog(@"Bidmad Sample App Reward Close");
    [[self rewardCallbackDisplay] setText:@"Close"];
}

- (void)BIDMADOpenBiddingRewardVideoSucceed:(OpenBiddingRewardVideo *)core {
    NSLog(@"Bidmad Sample App Reward Success");
    [[self rewardCallbackDisplay] setText:@"Success"];
}

- (void)BIDMADOpenBiddingRewardVideoAllFail:(OpenBiddingRewardVideo *)core {
    NSLog(@"Bidmad Sample App Reward All Fail");
    [[self rewardCallbackDisplay] setText:@"All Fail"];
}

@end
