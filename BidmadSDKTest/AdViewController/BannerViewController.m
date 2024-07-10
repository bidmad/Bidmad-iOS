//
//  BannerViewController.m
//  AdopSDKTest
//
//  Created by 김선정 on 2017. 9. 13..
//  Copyright © 2017년 김선정. All rights reserved.
//

#import "BannerViewController.h"
#import <CommonCrypto/CommonCrypto.h>
@import OpenBiddingHelper;

@interface BannerViewController () <BIDMADOpenBiddingBannerDelegate> {
    BidmadBannerAd *bannerAd;
}

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *zoneID = @"1c3e3085-333f-45af-8427-2810c26a72fc";
    
    bannerAd = [[BidmadBannerAd alloc] initWith:self containerView:self.BannerContainer zoneID:zoneID];
    bannerAd.delegate = self;
    [bannerAd setRefreshInterval:[@60 integerValue]];

    // Bidmad Banner Ads can be set with Custom Unique ID with the following method.
    [BidmadCommon setCuid:@"YOUR ENCRYPTED ID"];
}

- (IBAction)loadBanner:(id)sender {
    [bannerAd load];
}
- (IBAction)actionButtonPressend:(UIButton *)sender {
    if ([[[sender titleLabel] text] isEqualToString:@"Banner Hide"]) {
        [bannerAd hide];
    } else if ([[[sender titleLabel] text] isEqualToString:@"Banner Show"]) {
        [bannerAd show];
    }
}

#pragma mark Banner Deleagate

- (IBAction)backBtn:(id)sender {
    NSLog(@"Back Button Pressed");
    
    [bannerAd remove];     //광고 삭제
    [self dismissViewControllerAnimated:YES completion:^{
        // DO NOTHING;
    }];
}

- (void)onLoadAd:(OpenBiddingBanner *)bidmadAd {
    [[self bannerCallbackDisplay] setText:@"Load"];
    NSLog(@"Bidmad Sample App Banner Load");
}

- (void)onClickAd:(OpenBiddingBanner *)bidmadAd {
    [[self bannerCallbackDisplay] setText:@"Click"];
    NSLog(@"Bidmad Sample App Banner Click");
}

- (void)onLoadFailAd:(OpenBiddingBanner *)bidmadAd error:(NSError *)error {
    [[self bannerCallbackDisplay] setText:@"All Fail"];
    NSLog(@"Bidmad Sample App Banner All Fail");
}

@end
