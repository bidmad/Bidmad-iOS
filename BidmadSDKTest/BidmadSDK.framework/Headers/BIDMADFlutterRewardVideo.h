//
//  BIDMADFlutterRewardVideo.h
//  BidmadSDK
//
//  Created by ADOP_Mac on 2021/03/26.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "BIDMADRewardVideo.h"
#import "BIDMADSetting.h"

@interface BIDMADFlutterRewardVideo : NSObject<BIDMADRewardVideoDelegate>

@property (strong, nonatomic) FlutterMethodChannel* flutterChannel;
- (id)initRewardVideo:(NSObject<FlutterPluginRegistrar>*)registrar channelName:(NSString*)chanNm;

@end
