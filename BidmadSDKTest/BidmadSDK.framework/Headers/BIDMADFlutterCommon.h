//
//  BIDMADFlutterCommon.h
//  BidmadSDK
//
//  Created by ADOP_Mac on 2021/03/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BIDMADFlutterCommon : NSObject

- (void)initChannel: (NSObject<FlutterPluginRegistrar>*)registrar;

@property (strong, nonatomic) FlutterMethodChannel* flutterChannel;

@property (strong, nonatomic) NSString * channelName;

@end

NS_ASSUME_NONNULL_END
