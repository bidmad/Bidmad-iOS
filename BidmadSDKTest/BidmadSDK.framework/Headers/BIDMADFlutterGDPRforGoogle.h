//
//  BIDMADFlutter-GDPR-UMP.h
//  BidmadSDK
//
//  Created by ADOP_Mac on 2021/04/06.
//

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <UserMessagingPlatform/UserMessagingPlatform.h>
#import "BIDMADGDPRforGoogle.h"

@interface BIDMADFlutterGDPRforGoogle : NSObject<BIDMADGDPRforGoogleProtocol>

@property (strong, nonatomic) FlutterMethodChannel* flutterChannel;
- (id)initGDPRforGoogle:(NSObject<FlutterPluginRegistrar>*)registrar channelName:(NSString*)chanNm;

@end
