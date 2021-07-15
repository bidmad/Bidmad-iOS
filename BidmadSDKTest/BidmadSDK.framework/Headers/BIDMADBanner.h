//
//  BIDMADBanner.h
//  BIDMADMobileAds
//
//  Created by 김선정 on 2015. 7. 13..
//  Copyright (c) 2015년 ADOP Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDMADUtil.h"
#import "BIDMADSetting.h"
#import "BIDMADFacebook.h"
#import "BIDMADAtom.h"
#import "BIDMADAdmob.h"
#import "BIDMADUnityAds.h"
#import "BIDMADAdmanager.h"
#import "BIDMADPangleBanner.h"

#if __has_include(<AdFitSDK/AdFitSDK.h>) || __has_include("AdFitSDK.h")
#import "BIDMADAdFit.h"
#define ADFITSDK_EXIST
#endif

@protocol BIDMADBannerDelegate;

@protocol BIDMADBannerInnerDelegate <NSObject>

@optional

- (void)onBannerAllFail:(BIDMADBanner *)core;
- (void)onBannerError:(BIDMADBanner *)core code:(NSString *)error failType:(NSString*)failType current:(NSDictionary*)currentDic passbackStr:(NSString*) passBackStr passback:(NSDictionary*) passbackDic;
- (void)onBannerClosed:(BIDMADBanner *)core current:(NSDictionary*) currentDic;
- (void)onBannerLoad:(BIDMADBanner *)core current:(NSDictionary*) currentDic;
- (void)onBannerClick:(BIDMADBanner*) core current:(NSDictionary*) currentDic;

@end

@interface BIDMADBanner : UIView<BIDMADBannerInnerDelegate>

@property (assign, nonatomic) SEL requestSelector;
@property (strong, nonatomic) NSDictionary* ads_dic;
@property (nonatomic) bannerSizeType bannerType;
@property (strong, nonatomic) id<BIDMADBannerDelegate> delegate;
@property (strong, nonatomic) id<BIDMADBannerInnerDelegate> innerDelegate;

@property (strong, nonatomic) NSDictionary* ecmp_rev_info;
@property (strong, nonatomic) NSDictionary* area_info;

@property (strong, nonatomic) NSDictionary* change_info;
@property (strong, nonatomic) NSDictionary* date;

@property (nonatomic) int mediationNumber;

@property (nonatomic) BOOL isLabelService;

@property (nonatomic) BOOL isLabelServiceAdmin;

@property (nonatomic) NSString* realZoneId;

@property (nonatomic) NSString* zoneID;

@property (nonatomic, assign) int refreshInterval;

@property (nonatomic, strong) NSString* houseBannerImgPath;

@property (nonatomic) BOOL isRepeat; //default YES

@property (nonatomic, strong) NSString* currentAdNetwork;

/// INITIALIZE ADS
- (id)initWithParentViewController:(UIViewController *)parentVC adsPosition:(CGPoint)pointn bannerSize:(bannerSizeType) bannerTypeParam;
- (id)initWithParentViewController:(UIViewController *)parentVC rootView:(UIView *)view    bannerSize:(bannerSizeType) bannerTypeParam;
/// REQUEST ADS
- (void)requestBannerView;
/// DELETE ADS
- (void)removeAds;
- (void)selectAds:(NSDictionary *)lv_dic isAdsExist:(BOOL)isAds;
- (void)runAds;
- (void)setParentController:(UIViewController *)parentVC;
- (void)hideView;
- (void)showView;

@end

@protocol BIDMADBannerDelegate <NSObject>

@optional

- (void)BIDMADBannerAllFail:(BIDMADBanner *)core;
- (void)BIDMADBannerError:(BIDMADBanner *)core code:(NSString *)error;
- (void)BIDMADBannerClosed:(BIDMADBanner *)core;
- (void)BIDMADBannerLoad:(BIDMADBanner *)core;
- (void)BIDMADBannerClick:(BIDMADBanner*) core;

@end
