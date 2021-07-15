//
//  RewardViewController.h
//  BidmadSDKTest
//
//  Created by 김선정 on 2018. 10. 30..
//  Copyright © 2018년 김선정. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BidmadSDK/BidmadSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface RewardViewController : UIViewController<BIDMADRewardVideoDelegate>
@property BIDMADRewardVideo* reward;
@property (weak, nonatomic) IBOutlet UIButton* load;
@property (weak, nonatomic) IBOutlet UIButton* show;
@property (weak, nonatomic) IBOutlet UILabel* rewardCallbackDisplay;
@end

NS_ASSUME_NONNULL_END
