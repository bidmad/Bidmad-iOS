//
//  AppDelegate.m
//  AdopSDKTest
//
//  Created by 김선정 on 2017. 9. 13..
//  Copyright © 2017년 김선정. All rights reserved.
//

#import "AppDelegate.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
@import BidmadSDK;

#define DEBUG_MODE
@interface AppDelegate () <BIDMADAppOpenAdDelegate>

@end

@implementation AppDelegate {
    BIDMADAppOpenAd *bidmadAppOpenAd;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[BIDMADSetting sharedInstance] reqAdTrackingAuthorizationWithCompletionHandler:^(BidmadTrackingAuthorizationStatus status) {
        if(status == BidmadAuthorizationStatusAuthorized){
            NSLog(@" IDFA  수집 동의 ");
        }else if(status == BidmadAuthorizationStatusDenied) {
            NSLog(@" IDFA  수집 거부 ");
        }else if(status == BidmadAuthorizationStatusLessThaniOS14) {
            NSLog(@" IDFA  iOS 14 이하 버전 ");
        }
    }];
    
    [[BIDMADSetting sharedInstance] setIsDebug:YES];
    bidmadAppOpenAd = [[BIDMADAppOpenAd alloc] init];
    [bidmadAppOpenAd setDelegate: self];
    [bidmadAppOpenAd registerForAppOpenAdForZoneID: @"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
    return YES;
}

- (void)cancelAppOpenAd {
    [bidmadAppOpenAd deregisterForAppOpenAd];
}

- (void)reloadAppOpenAd {
    [bidmadAppOpenAd registerForAppOpenAdForZoneID: @"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
}

- (void)BIDMADAppOpenAdAllFail:(BIDMADAppOpenAd *)core code:(NSString *)error {
    NSLog(@"BidmadSDK App Open Ad Callback → AllFail");
    [self callbackLabelViewShow: @"App Open Ad Callback → AllFail"];
}

- (void)BIDMADAppOpenAdLoad:(BIDMADAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Load");
    [self callbackLabelViewShow: @"App Open Ad Callback → Load"];
}

- (void)BIDMADAppOpenAdShow:(BIDMADAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Show");
    [self callbackLabelViewShow: @"App Open Ad Callback → Show"];
}

- (void)BIDMADAppOpenAdClose:(BIDMADAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Close");
    [self callbackLabelViewShow: @"App Open Ad Callback → Close"];
}

- (void)callbackLabelViewShow: (NSString *)callbackText {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *topVC = self.window.rootViewController;
        while (topVC.presentedViewController != nil) {
            topVC = topVC.presentedViewController;
        }
        
        CGFloat notiSizeWidth = 320;
        CGFloat notiSizeHeight = 50;
        CGFloat x = ([[topVC view] frame].size.width - notiSizeWidth) / 2;
        CGFloat y = ([[topVC view] frame].size.height - notiSizeHeight) / 2;
        UILabel *smallNotificationView = [[UILabel alloc] initWithFrame: CGRectMake(x, y, notiSizeWidth, notiSizeHeight)];
        [smallNotificationView setAlpha:0.0f];
        [smallNotificationView setText:callbackText];
        [smallNotificationView setTextColor: [UIColor systemBlueColor]];
        [smallNotificationView setAdjustsFontSizeToFitWidth:YES];
        [smallNotificationView setFont:[UIFont systemFontOfSize:24.0f weight:UIFontWeightBold]];
        
        [[topVC view] addSubview:smallNotificationView];
        [UIView animateWithDuration:1.0f animations:^{
            [smallNotificationView setAlpha:1.0f];
        } completion:^(BOOL finished) {
            dispatch_after(4, dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0f animations:^{
                    [smallNotificationView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [smallNotificationView removeFromSuperview];
                }];
            });
        }];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {}


- (void)applicationWillTerminate:(UIApplication *)application {}


@end
