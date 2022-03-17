//
//  InterstitialViewController.m
//  BidmadSDKTest
//
//  Created by 김선정 on 2017. 9. 13..
//  Copyright © 2017년 김선정. All rights reserved.
//

#import "InterstitialViewController.h"
@import OpenBiddingHelper;

@interface InterstitialViewController () <BIDMADOpenBiddingInterstitialDelegate> {
    BidmadInterstitialAd *interstitialAd;
}

@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *zoneID = @"228b95a9-6f42-46d8-a40d-60f17f751eb1";
    interstitialAd = [[BidmadInterstitialAd alloc] initWith:self zoneID:zoneID];
    [interstitialAd setDelegate: self];
    
    // Bidmad Interstitial Ads can be set with Custom Unique ID with the following method.
    [interstitialAd setCUID:@"YOUR ENCRYPTED ID"];
    
    // Auto Reload feature can be turned on and off with the following method
    [interstitialAd setIsAutoReload:YES]; // Default is YES (Auto Reload turned ON)
}

-(IBAction)loadInterstitial:(UIButton*)sender{
    [interstitialAd load];
}

-(IBAction)showInterstitial:(UIButton*)sender{
    if ([interstitialAd isLoaded])
        [interstitialAd show];
}

- (IBAction)backBtnPressed:(id)sender {
    NSLog(@"Back Button Pressed");
    
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark Interstitial Delegate

- (void)BIDMADOpenBiddingInterstitialLoad:(OpenBiddingInterstitial *)core {
    NSLog(@"Bidmad Sample App Interstitial Load");
    [[self InterstitialCallbackDisplay] setText:@"Load"];
}

- (void)BIDMADOpenBiddingInterstitialShow:(OpenBiddingInterstitial *)core {
    NSLog(@"Bidmad Sample App Interstitial Show");
    [[self InterstitialCallbackDisplay] setText:@"Show"];
}

- (void)BIDMADOpenBiddingInterstitialClose:(OpenBiddingInterstitial *)core {
    NSLog(@"Bidmad Sample App Interstitial Close");
    [[self InterstitialCallbackDisplay] setText:@"Close"];
}

- (void)BIDMADOpenBiddingInterstitialAllFail:(OpenBiddingInterstitial *)core {
    NSLog(@"Bidmad Sample App Interstitial AllFail");
    [[self InterstitialCallbackDisplay] setText:@"All Fail"];
}

@end
