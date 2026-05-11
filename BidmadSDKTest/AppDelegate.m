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
@interface AppDelegate () <BIDMADGDPRforGoogleProtocol>

@end

@implementation AppDelegate {
    BIDMADGDPRforGoogle *gdpr;

    BOOL didRequestATTPopup;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    didRequestATTPopup = NO;
    [BidmadCommon initializeSdkWithCompletionHandler:^(BOOL isInitialized) {
        NSLog(@"Bidmad Sample App: Initialized %@", isInitialized ? @"YES" : @"NO");
    }];

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

- (void)cancelAppOpenAd {}

- (void)reloadAppOpenAd {}

- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (!didRequestATTPopup) {
        bidmadWeakify(self)
        [BidmadCommon reqAdTrackingAuthorizationWith:^(BidmadTrackingAuthorizationStatus status) {
            bidmadStrongify(self)
            
            if(status == BidmadTrackingAuthorizationStatusAuthorized){
                NSLog(@"Bidmad Sample App: IDFA Authorized");
            }else if(status == BidmadTrackingAuthorizationStatusDenied) {
                NSLog(@"Bidmad Sample App: IDFA Unauthorized");
            }else if(status == BidmadTrackingAuthorizationStatusLessThaniOS14) {
                NSLog(@"Bidmad Sample App: iOS Version lower than iOS 14");
            }
            
            self->didRequestATTPopup = YES;
        }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {}


@end
