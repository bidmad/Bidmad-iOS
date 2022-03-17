//
//  RewardInterstitialViewController.m
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/05.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import "RewardInterstitialViewController.h"
@import OpenBiddingHelper;

@interface RewardInterstitialViewController () <OpenBiddingRewardInterstitialDelegate>

@end

@implementation RewardInterstitialViewController {
    BidmadRewardInterstitialAd *rewardInterstitialAd;
    
    SegueInterimAdVIew *adView;
    UIButton *reloadButton;
    UILabel *callbackLabelView;
    __weak IBOutlet UIButton *backButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [[BIDMADSetting sharedInstance] setIsDebug:YES];
    
    [self setupRewardInterstitial];
    
    adView = [[SegueInterimAdVIew alloc] init];
    CGRect viewControllerBoundaries = [[self view] bounds];
    
    // MAKE RELOAD BUTTON
        reloadButton = [[UIButton alloc] initWithFrame:CGRectMake((viewControllerBoundaries.size.width - 150) / 2,
                                                                  (viewControllerBoundaries.size.height - 50) / 2,
                                                                  150, 50)];
        [reloadButton setTitle:@"RELOAD AD" forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(reloadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [reloadButton setBackgroundColor: UIColor.systemGreenColor];
        [reloadButton.layer setCornerRadius: 10];
        [reloadButton.layer setShadowRadius: 3];
        [reloadButton.layer setShadowColor: UIColor.grayColor.CGColor];
        [reloadButton.layer setShadowOpacity: 0.4];
        [reloadButton.layer setShadowOffset:CGSizeMake(0, 2)];
        [[self view] addSubview: reloadButton];
        
        [adView setFrame:CGRectMake((viewControllerBoundaries.size.width - [adView frame].size.width) / 2,
                                    (viewControllerBoundaries.size.height - [adView frame].size.height) / 2,
                                    [adView frame].size.width,
                                    [adView frame].size.height)];
        [[self view] addSubview: adView];
        
        callbackLabelView = [[UILabel alloc] initWithFrame:CGRectMake((viewControllerBoundaries.size.width - 320) / 2,
                                                                      (viewControllerBoundaries.size.height - 100) / 4,
                                                                      320, 100)];
        [adView setAdAvailableDelegate: self];
    
    // Set Callback Text and Delegate
        [callbackLabelView setText: @"No Callback Yet"];
        [callbackLabelView setTextAlignment:NSTextAlignmentCenter];
        [callbackLabelView setFont:[UIFont systemFontOfSize:22]];
        [[self view] addSubview: callbackLabelView];
}

- (void)reloadButtonPressed {
    if (![rewardInterstitialAd isLoaded])
        [self setupRewardInterstitial];
    
    CGRect viewControllerBoundaries = [[self view] bounds];
    adView = nil;
    adView = [[SegueInterimAdVIew alloc] init];
    [adView setFrame:CGRectMake((viewControllerBoundaries.size.width - [adView frame].size.width) / 2,
                                (viewControllerBoundaries.size.height - [adView frame].size.height) / 2,
                                [adView frame].size.width,
                                [adView frame].size.height)];
    [[self view] addSubview: adView];
    [adView setAdAvailableDelegate:self];
}

- (void)setupRewardInterstitial {
    rewardInterstitialAd = [[BidmadRewardInterstitialAd alloc] initWith:self zoneID:@"ee6e601d-2232-421b-a429-2e7163a8b41f"];
    rewardInterstitialAd.delegate = self;
    [rewardInterstitialAd load];
    
    // Ads can be set with Custom Unique ID with the following method.
    [rewardInterstitialAd setCUID:@"YOUR ENCRYPTED ID"];
    
    // Auto Reload feature can be turned on and off with the following method
    [rewardInterstitialAd setIsAutoReload:YES]; // Default is YES (Auto Reload turned ON)
}

- (void)adAvailable {
    NSLog(@"Ad is available");
    if (rewardInterstitialAd.isLoaded) {
        [rewardInterstitialAd show];
    }
}

- (void)adShowCancelled {
    NSLog(@"User cancelled showing the ad");
    rewardInterstitialAd = nil;
    adView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isBeingDismissed) {
        [self removeAll];
    }
}

- (void)dealloc {
    [self removeAll];
}

- (void)removeAll {
    if (rewardInterstitialAd != nil) {
        NSLog(@"Removing Reward Interstitial Ads");
        rewardInterstitialAd = nil;
    }
    
    if (adView != nil) {
        adView = nil;
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [adView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)OpenBiddingRewardInterstitialLoad:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Bidmad Sample App RewardInterstitial Load");
    [self->callbackLabelView setText:@"Load"];
}

- (void)OpenBiddingRewardInterstitialShow:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Bidmad Sample App RewardInterstitial Show");
    [self->callbackLabelView setText:@"Show"];
}

- (void)OpenBiddingRewardInterstitialClick:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Bidmad Sample App RewardInterstitial Click");
    [self->callbackLabelView setText:@"Click"];
}

- (void)OpenBiddingRewardInterstitialClose:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Bidmad Sample App RewardInterstitial Close");
    [self->callbackLabelView setText:@"Close"];
}

- (void)OpenBiddingRewardInterstitialSkipped:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Bidmad Sample App RewardInterstitial Skipped");
    [self->callbackLabelView setText:@"Skipped"];
}

- (void)OpenBiddingRewardInterstitialSuccess:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Bidmad Sample App RewardInterstitial Success");
    [self->callbackLabelView setText:@"Success"];
}

- (void)OpenBiddingRewardInterstitialAllFail:(OpenBiddingRewardInterstitial *)core {
    NSLog(@"Bidmad Sample App RewardInterstitial All Fail");
    [self->callbackLabelView setText:@"All Fail"];
}


@end
