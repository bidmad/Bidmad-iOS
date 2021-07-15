//
//  SegueInterimAdVIew.h
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/05.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdAvailableDelegate
@required

- (void)adAvailable;
- (void)adShowCancelled;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SegueInterimAdVIew : UIView

@property BOOL isAdReadyForDisplay;
@property (strong, nonatomic) id<AdAvailableDelegate> adAvailableDelegate;

@end

NS_ASSUME_NONNULL_END
