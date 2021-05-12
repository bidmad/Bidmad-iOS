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

@interface OfferwallController : UIViewController<BIDMADOfferwallDelegate>
@property BIDMADOfferwall * offerwall;
@property (weak, nonatomic) IBOutlet UIButton* load;
@property (weak, nonatomic) IBOutlet UIButton* show;
@property (weak, nonatomic) IBOutlet UIButton* getCurrency;
@property (weak, nonatomic) IBOutlet UIButton* spndCurrency;
@property (weak, nonatomic) IBOutlet UILabel* textCurrency;
@property (weak, nonatomic) IBOutlet UITextField* inputSpendCurrency;
@property (weak, nonatomic) IBOutlet UILabel* offerwallCallbackDisplay;

-(void)renewBalance:(int)amount;

@end

NS_ASSUME_NONNULL_END
