//
//  AppDelegate.m
//  AdopSDKTest
//
//  Created by 김선정 on 2017. 9. 13..
//  Copyright © 2017년 김선정. All rights reserved.
//

#import "AppDelegate.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
@import OpenBiddingHelper;
@import BidmadSDK;

#define DEBUG_MODE
@interface AppDelegate () <BIDMADGDPRforGoogleProtocol, OpenBiddingAppOpenAdDelegate>

@end

@implementation AppDelegate {
    BidmadAppOpenAd *bidmadAppOpenAd;
    BIDMADGDPRforGoogle *gdpr;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BidmadCommon initializeSdk];
    
    [BidmadCommon reqAdTrackingAuthorizationWith:^(BidmadTrackingAuthorizationStatus status) {
        if(status == BidmadAuthorizationStatusAuthorized){
            NSLog(@"Bidmad Sample App: IDFA Authorized");
        }else if(status == BidmadAuthorizationStatusDenied) {
            NSLog(@"Bidmad Sample App: IDFA Unauthorized");
        }else if(status == BidmadAuthorizationStatusLessThaniOS14) {
            NSLog(@"Bidmad Sample App: iOS Version lower than iOS 14");
        }
    }];
    
    bidmadAppOpenAd = [[BidmadAppOpenAd alloc] initWith:self.window.rootViewController zoneID:@"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
    [bidmadAppOpenAd setDelegate:self];
    
    [BidmadCommon setIsChildDirectedAds:YES];
    [BidmadCommon setUserConsentStatusForCCPACompliance:YES];
    
    [BidmadCommon setIsDebug:YES];
    NSLog(@"Bidmad Sample App: [BidmadCommon isDebug] is %@", [NSNumber numberWithBool:[BidmadCommon isDebug]]);
    NSLog(@"Bidmad Sample App: [BidmadCommon bidmadVersion] is %@", [BidmadCommon bidmadVersion]);
    
    NSLog(@"Bidmad Sample App: [BidmadCommon isChildDirectedTreament] is %@", [BidmadCommon isChildDirectedTreatment]);
    NSLog(@"Bidmad Sample App: [BidmadCommon isUserConsentCCPA] is %@", [BidmadCommon isUserConsentCCPA]);
    
    [BidmadCommon setTestDeviceId:@"0772a1fad2e99786a321e67ac9de4a0f"];
    NSLog(@"Bidmad Sample App: [BidmadCommon testDeviceId] is %@", [BidmadCommon testDeviceId]);
    
    return YES;
}

- (void)requestGDPR {
    gdpr = [[BIDMADGDPRforGoogle alloc] initWith:[[[[UIApplication sharedApplication] windows] firstObject] rootViewController]];
    gdpr.consentStatusDelegate = self;
    [gdpr setDebug:@"D701554C-B328-4581-B7D0-B7B509ABFB84" isTestEurope:YES];
    [gdpr reset];
    [gdpr requestConsentInfoUpdate];
}

- (void)onConsentFormLoadSuccess {
    NSLog(@"Consent Form Load Success");
    [gdpr showForm];
}

- (void)onConsentFormLoadFailure:(NSError *)formError {
    NSLog(@"Consent Form Load Failed");
}

- (void)onConsentInfoUpdateSuccess {
    NSLog(@"Info Update");
    [gdpr loadForm];
}

- (void)onConsentInfoUpdateFailure:(NSError *)formError {
    NSLog(@"Info Update Fail");
}

- (void)onConsentFormDismissed:(NSError *)formError {
    NSLog(@"Consent Form Dismissed");
    if (formError != nil) {
        NSLog(@"Receiving Consent Failed");
    }
}

- (void)cancelAppOpenAd {
    [bidmadAppOpenAd deregisterForAppOpenAd];
}

- (void)reloadAppOpenAd {
    bidmadAppOpenAd = [[BidmadAppOpenAd alloc] initWith:self.window.rootViewController zoneID:@"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
}

- (void)BIDMADAppOpenAdAllFail:(BIDMADAppOpenAd *)core code:(NSString *)error {
    NSLog(@"BidmadSDK App Open Ad Callback → AllFail");
    [self callbackLabelViewShow: @"App Open Ad Callback → AllFail"];
}

- (void)OpenBiddingAppOpenAdLoad:(OpenBiddingAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Load");
    [self callbackLabelViewShow: @"App Open Ad Callback → Load"];
}

- (void)OpenBiddingAppOpenAdShow:(OpenBiddingAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Show");
    [self callbackLabelViewShow: @"App Open Ad Callback → Show"];
}

- (void)OpenBiddingAppOpenAdClick:(OpenBiddingAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Click");
    [self callbackLabelViewShow: @"App Open Ad Callback → Click"];
}

- (void)OpenBiddingAppOpenAdClose:(OpenBiddingAppOpenAd *)core {
    NSLog(@"BidmadSDK App Open Ad Callback → Close");
    [self callbackLabelViewShow: @"App Open Ad Callback → Close"];
}

- (void)OpenBiddingAppOpenAdAllFail:(OpenBiddingAppOpenAd *)core code:(NSString *)error {
    NSLog(@"BidmadSDK App Open Ad Callback → All Fail");
    [self callbackLabelViewShow: @"App Open Ad Callback → All Fail"];
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
