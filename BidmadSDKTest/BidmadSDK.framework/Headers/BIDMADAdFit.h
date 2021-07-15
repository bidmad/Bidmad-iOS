//
//  BIDMADAdFit.h
//  BidmadSDK
//
//  Created by ADOP_Mac on 2021/05/27.
//  Copyright © 2021 ADOP Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIDMADBanner.h"
@import AdFitSDK;

@interface BIDMADAdFit : NSObject<AdFitBannerAdViewDelegate>

@property (weak,nonatomic) BIDMADBanner* banner;

- (id)initWithAdBanner:(NSDictionary *)dic bidmadbanner:(BIDMADBanner *)banner;
- (void)adViewDidFailToReceiveAd:(AdFitBannerAdView *)bannerAdView error:(NSError *)error;
- (void)adViewDidReceiveAd:(AdFitBannerAdView *)bannerAdView;
- (void)adViewDidClickAd:(AdFitBannerAdView *)bannerAdView;
- (void)showAdfitBanner:(UIViewController *)pvc bannerContainer:(UIView *)bannerContainer;
- (void)positionBannerViewFullWidthAtBottomOfSafeAreaEx:(UIView *_Nonnull)bannerView NS_AVAILABLE_IOS(11.0);
- (void)positionBannerViewFullWidthAtBottomOfSafeArea:(UIView *_Nonnull)bannerView NS_AVAILABLE_IOS(11.0);
- (void)positionBannerViewFullWidthAtBottomOfView:(UIView *_Nonnull)bannerView;
- (void)removeBannerAds;

@end
