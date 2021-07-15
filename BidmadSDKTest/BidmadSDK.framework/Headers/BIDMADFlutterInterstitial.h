//
//  BIDMADFlutterInterstitial.h
//  BidmadSDK
//
//  Created by ADOP_Mac on 2021/03/26.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "BIDMADInterstitial.h"
#import "BIDMADSetting.h"

@interface BIDMADFlutterInterstitial : NSObject<BIDMADInterstitialDelegate>

@property (strong, nonatomic) FlutterMethodChannel* flutterChannel;
- (id)initInterstitial:(NSObject<FlutterPluginRegistrar>*)registrar channelName:(NSString*)chanNm;

@end
