#import "Flutter3desPlugin.h"

#import <Flutter/Flutter.h>
#import "JKEncrypt.h"  // 3DES加密

@implementation Flutter3desPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_3des_plugin"
            binaryMessenger:[registrar messenger]];
  Flutter3desPlugin* instance = [[Flutter3desPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"encrypt" isEqualToString:call.method]) {
    NSDictionary* argsMap=call.arguments;
    NSString * data=argsMap[@"data"];
    NSString * key=argsMap[@"key"];
    NSString *batteryLevel = [self encrypt:data key:key];
    if (batteryLevel) {
        result(batteryLevel);
    } else
    {
        result([FlutterError errorWithCode:@"UNAVAILABLE"
        message:@"Battery info unavailable"
        details:nil]);
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString *)encrypt:(NSString *)data key:(NSString *)key {
    JKEncrypt * en = [[JKEncrypt alloc]init];
    //加密
    NSString * encryptStr = [en encrypt3DesStr:data key:key];
    
    return encryptStr;
}

@end
