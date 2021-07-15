#import <Flutter/Flutter.h>
#import "BIDMADFlutterCommon.h"

@interface BIDMADFlutterBannerFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
@end
