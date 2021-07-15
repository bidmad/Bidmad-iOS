//
//  BIDMADFlutterBanner.h
//  BidmadSDK
//
//  Created by ADOP_Mac on 2021/03/25.
//
#import <UIKit/UIKit.h>
#import "BIDMADSetting.h"
#import "BIDMADBanner.h"
#import <Flutter/Flutter.h>

@interface BIDMADFlutterBanner : NSObject<BIDMADBannerDelegate, FlutterPlatformView>

@property (strong, nonatomic) FlutterMethodChannel* flutterChannel;
- (id)initBanner:(NSObject<FlutterPluginRegistrar>*)registrar channelName:(NSString*)chanNm frame:(CGRect)frame;

- (UIView*)view;

@end
