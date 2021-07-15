//
//  RewardInterstitialViewController.h
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/05.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BidmadSdk/BIDMADRewardInterstitial.h>
#import "SegueInterimAdVIew.h"

NS_ASSUME_NONNULL_BEGIN

@interface RewardInterstitialViewController : UIViewController<BIDMADRewardInterstitialDelegate, AdAvailableDelegate>

- (void)adAvailable;

- (void)BIDMADRewardInterstitialLoad:(BIDMADRewardInterstitial *)core;
- (void)BIDMADRewardInterstitialShow:(BIDMADRewardInterstitial *)core;
- (void)BIDMADRewardInterstitialClick:(BIDMADRewardInterstitial *)core;
- (void)BIDMADRewardInterstitialClose:(BIDMADRewardInterstitial *)core;
- (void)BIDMADRewardInterstitialSkipped:(BIDMADRewardInterstitial *)core;
- (void)BIDMADRewardInterstitialSuccess:(BIDMADRewardInterstitial *)core;
- (void)BIDMADRewardInterstitialComplete:(BIDMADRewardInterstitial *)core;
- (void)BIDMADRewardInterstitialAllFail:(BIDMADRewardInterstitial *)core;

@end

NS_ASSUME_NONNULL_END
