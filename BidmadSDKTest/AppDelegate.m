//
//  AppDelegate.m
//  AdopSDKTest
//
//  Created by 김선정 on 2017. 9. 13..
//  Copyright © 2017년 김선정. All rights reserved.
//

#import "AppDelegate.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <ADOPUtility/ADOPLog.h>
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
    
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"926e928b8b1964c256f30292dd3f4799" ];
    
    [BidmadCommon reqAdTrackingAuthorizationWith:^(BidmadTrackingAuthorizationStatus status) {
        if(status == BidmadAuthorizationStatusAuthorized){
            ADOPLog.printInfo(@"Bidmad Sample App: IDFA Authorized");
        }else if(status == BidmadAuthorizationStatusDenied) {
            ADOPLog.printInfo(@"Bidmad Sample App: IDFA Unauthorized");
        }else if(status == BidmadAuthorizationStatusLessThaniOS14) {
            ADOPLog.printInfo(@"Bidmad Sample App: iOS Version lower than iOS 14");
        }
    }];
    
    bidmadAppOpenAd = [[BidmadAppOpenAd alloc] initWith:self.window.rootViewController zoneID:@"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
    [bidmadAppOpenAd setDelegate:self];
    
    [BidmadCommon setIsChildDirectedAds:YES];
    [BidmadCommon setUserConsentStatusForCCPACompliance:YES];
    
    [BidmadCommon setIsDebug:YES];
    ADOPLog.printInfo(@"Bidmad Sample App: [BidmadCommon isDebug] is %@", [NSNumber numberWithBool:[BidmadCommon isDebug]]);
    ADOPLog.printInfo(@"Bidmad Sample App: [BidmadCommon bidmadVersion] is %@", [BidmadCommon bidmadVersion]);
    
    ADOPLog.printInfo(@"Bidmad Sample App: [BidmadCommon isChildDirectedTreament] is %@", [BidmadCommon isChildDirectedTreatment]);
    ADOPLog.printInfo(@"Bidmad Sample App: [BidmadCommon isUserConsentCCPA] is %@", [BidmadCommon isUserConsentCCPA]);
    
    [BidmadCommon setTestDeviceId:@"0772a1fad2e99786a321e67ac9de4a0f"];
    ADOPLog.printInfo(@"Bidmad Sample App: [BidmadCommon testDeviceId] is %@", [BidmadCommon testDeviceId]);
    
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
    ADOPLog.printInfo(@"Consent Form Load Success");
    [gdpr showForm];
}

- (void)onConsentFormLoadFailure:(NSError *)formError {
    ADOPLog.printInfo(@"Consent Form Load Failed");
}

- (void)onConsentInfoUpdateSuccess {
    ADOPLog.printInfo(@"Info Update");
    [gdpr loadForm];
}

- (void)onConsentInfoUpdateFailure:(NSError *)formError {
    ADOPLog.printInfo(@"Info Update Fail");
}

- (void)onConsentFormDismissed:(NSError *)formError {
    ADOPLog.printInfo(@"Consent Form Dismissed");
    if (formError != nil) {
        ADOPLog.printInfo(@"Receiving Consent Failed");
    }
}

- (void)cancelAppOpenAd {
    [bidmadAppOpenAd deregisterForAppOpenAd];
}

- (void)reloadAppOpenAd {
    bidmadAppOpenAd = [[BidmadAppOpenAd alloc] initWith:self.window.rootViewController zoneID:@"0ddd6401-0f19-49ee-b1f9-63e910f92e77"];
}

- (void)BIDMADAppOpenAdAllFail:(BIDMADAppOpenAd *)core code:(NSString *)error {
    ADOPLog.printInfo(@"BidmadSDK App Open Ad Callback → AllFail");
    [self callbackLabelViewShow: @"App Open Ad Callback → AllFail"];
}

- (void)OpenBiddingAppOpenAdLoad:(OpenBiddingAppOpenAd *)core {
    ADOPLog.printInfo(@"BidmadSDK App Open Ad Callback → Load");
    [self callbackLabelViewShow: @"App Open Ad Callback → Load"];
}

- (void)OpenBiddingAppOpenAdShow:(OpenBiddingAppOpenAd *)core {
    ADOPLog.printInfo(@"BidmadSDK App Open Ad Callback → Show");
    [self callbackLabelViewShow: @"App Open Ad Callback → Show"];
}

- (void)OpenBiddingAppOpenAdClick:(OpenBiddingAppOpenAd *)core {
    ADOPLog.printInfo(@"BidmadSDK App Open Ad Callback → Click");
    [self callbackLabelViewShow: @"App Open Ad Callback → Click"];
}

- (void)OpenBiddingAppOpenAdClose:(OpenBiddingAppOpenAd *)core {
    ADOPLog.printInfo(@"BidmadSDK App Open Ad Callback → Close");
    [self callbackLabelViewShow: @"App Open Ad Callback → Close"];
}

- (void)OpenBiddingAppOpenAdAllFail:(OpenBiddingAppOpenAd *)core code:(NSString *)error {
    ADOPLog.printInfo(@"BidmadSDK App Open Ad Callback → All Fail");
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
