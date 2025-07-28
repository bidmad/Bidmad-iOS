//
//  FullscreenAdViewController.h
//  BidmadSDKTest
//
//  Created by Seungsub Oh on 7/24/25.
//  Copyright © 2025 전혜연. All rights reserved.
//

#import <OpenBiddingHelper/OpenBiddingHelper.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FullscreenAdViewController : UIViewController <BidmadFullscreenAdDelegate>

@property(nonatomic, weak) IBOutlet UILabel *callbacks;
@property(nonatomic, weak) IBOutlet UIButton *loadAd;
@property(nonatomic, weak) IBOutlet UIButton *showAd;
@property(nonatomic, weak) IBOutlet UIButton *autoReloadToggle;
@property(nonatomic, strong) BidmadFullscreenAd *ad;

@end

NS_ASSUME_NONNULL_END
