//
//  RewardInterstitialViewController.m
//  BidmadSDKTest
//
//  Created by ADOP_Mac on 2021/07/05.
//  Copyright © 2021 전혜연. All rights reserved.
//

#import "RewardInterstitialViewController.h"
#import <BidmadSDK/BIDMADSetting.h>
@import GoogleMobileAds;

@interface RewardInterstitialViewController ()

@end

@implementation RewardInterstitialViewController {
    BIDMADRewardInterstitial *rewardInterstitial;
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
    
    reloadButton = [[UIButton alloc] initWithFrame:CGRectMake((viewControllerBoundaries.size.width - 150) / 2,
                                                              (viewControllerBoundaries.size.height - 50) / 2,
                                                              150,
                                                              50)];
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
    [callbackLabelView setText: @"No Callback Yet"];
    [callbackLabelView setTextAlignment:NSTextAlignmentCenter];
    [callbackLabelView setFont:[UIFont systemFontOfSize:22]];
    [[self view] addSubview: callbackLabelView];
    [adView setAdAvailableDelegate: self];
}

- (void)reloadButtonPressed {
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
    rewardInterstitial = nil;
    rewardInterstitial = [[BIDMADRewardInterstitial alloc] init];
    rewardInterstitial.zoneID = @"ee6e601d-2232-421b-a429-2e7163a8b41f";
    rewardInterstitial.parentViewController = self;
    rewardInterstitial.delegate = self;
    [rewardInterstitial requestRewardInterstitial];
}

- (void)adAvailable {
    NSLog(@"Ad is available");
    if (rewardInterstitial.isLoaded) {
        [rewardInterstitial showRewardInterstitialView];
    }
}

- (void)adShowCancelled {
    NSLog(@"User cancelled showing the ad");
    [rewardInterstitial removeRewardInterstitialAds];
    rewardInterstitial = nil;
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
    if (rewardInterstitial != nil) {
        NSLog(@"Removing Reward Interstitial Ads");
        [rewardInterstitial removeRewardInterstitialAds];
        rewardInterstitial = nil;
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

- (void)BIDMADRewardInterstitialLoad:(BIDMADRewardInterstitial *)core {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->callbackLabelView setText: @"Load"];
    });
    NSLog(@"BIDMADRewardInterstitialLoad");
}

- (void)BIDMADRewardInterstitialShow:(BIDMADRewardInterstitial *)core {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->callbackLabelView setText: @"Show"];
    });
    NSLog(@"BIDMADRewardInterstitialShow");
}

- (void)BIDMADRewardInterstitialClick:(BIDMADRewardInterstitial *)core {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->callbackLabelView setText: @"Click"];
    });
    NSLog(@"BIDMADRewardInterstitialClick");
}

- (void)BIDMADRewardInterstitialClose:(BIDMADRewardInterstitial *)core {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->callbackLabelView setText: @"Close"];
    });
    NSLog(@"BIDMADRewardInterstitialClose");
}

- (void)BIDMADRewardInterstitialSkipped:(BIDMADRewardInterstitial *)core {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->callbackLabelView setText: @"Skipped"];
    });
    NSLog(@"BIDMADRewardInterstitialSkipped");
}

- (void)BIDMADRewardInterstitialSuccess:(BIDMADRewardInterstitial *)core {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->callbackLabelView setText: @"Success"];
    });
    NSLog(@"BIDMADRewardInterstitialSuccess");
}

- (void)BIDMADRewardInterstitialComplete:(BIDMADRewardInterstitial *)core {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->callbackLabelView setText: @"Complete"];
    });
    NSLog(@"BIDMADRewardInterstitialComplete");
}

- (void)BIDMADRewardInterstitialAllFail:(BIDMADRewardInterstitial *)core {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->callbackLabelView setText: @"AllFail"];
    });
    NSLog(@"BIDMADRewardInterstitialAllFail");
}

@end
