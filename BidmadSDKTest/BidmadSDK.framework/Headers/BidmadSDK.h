//
//  BidmadSDK.h
//  BidmadSDK
//
//  Created by 김선정 on 2015. 7. 14..
//  Copyright (c) 2015년 ADOP Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for BidmadSDK.
FOUNDATION_EXPORT double BidmadSDKVersionNumber;

//! Project version string for BidmadSDK.
FOUNDATION_EXPORT const unsigned char BidmadSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BidmadSDK/PublicHeader.h>

#if __has_include(<Flutter/Flutter.h>) || __has_include("Flutter.h")
#define FLUTTER_EXIST
#endif

#if __has_include(<Tapjoy/Tapjoy.h>) || __has_include("Tapjoy.h")
#define TAPJOY_EXIST
#endif

#if __has_include(<AdFitSDK/AdFitSDK.h>) || __has_include("AdFitSDK.h")
#define ADFITSDK_EXIST
#endif



#ifdef FLUTTER_EXIST
#import "BIDMADFlutterRewardVideo.h"
#import "BIDMADFlutterInterstitial.h"
#import "BIDMADFlutterGDPRforGoogle.h"
#import "BIDMADFlutterCommon.h"
#import "BIDMADFlutterBannerFactory.h"
#import "BIDMADFlutterBanner.h"
#endif

#ifdef TAPJOY_EXIST
#import "BIDMADTapjoy.h"
#endif

#import "BIDMADAdmanager.h"
#import "BIDMADRewardVideo.h"
#import "BIDMADInterstitial.h"
#import "BIDMADBanner.h"
#import "UnityReward.h"
#import "UnityInterstitial.h"
#import "UnityCommon.h"
#import "UnityBanner.h"
#import "KeychainItemWrapper.h"
#import "BIDMADUtil.h"
#import "BIDMADUnityAds.h"
#import "BIDMADSetting.h"
#import "BIDMADOfferwall.h"
#import "BIDMADLabelView.h"
#import "BIDMADGDPRforGoogle.h"
#import "BIDMADGDPR.h"
#import "BIDMADFacebook.h"
#import "BIDMADAtomReward.h"
#import "BIDMADAtomInterstitial.h"
#import "BIDMADAtom.h"
#import "BIDMADAppOpenAd.h"
#import "BIDMADAppLoving.h"
#import "BIDMADAdmob.h"
#import "BIDMADPangleBanner.h"
#import "BIDMADAdmobAppOpenAd.h"
#import "BIDMADAppOpenAd.h"

#ifdef ADFITSDK_EXIST
#import "BIDMADAdFit.h"
#endif
//#import "BIDMADRewardInterstitial.h"
