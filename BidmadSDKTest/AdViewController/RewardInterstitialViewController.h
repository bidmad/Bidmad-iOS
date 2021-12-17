//
//  RewardInterstitialViewController.h
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/05.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegueInterimAdVIew.h"

NS_ASSUME_NONNULL_BEGIN

@interface RewardInterstitialViewController : UIViewController<AdAvailableDelegate>

- (void)adAvailable;

@end

NS_ASSUME_NONNULL_END
