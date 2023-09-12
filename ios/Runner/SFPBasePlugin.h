

#import <Foundation/Foundation.h>

#import <Flutter/Flutter.h>

typedef NS_ENUM(NSInteger, ANBFlutterErrorCode) {
    ANBFlutterErrorCodeParasInvalid = -503,
    ANBFlutterErrorCodeNotImplement = -404
};

NS_ASSUME_NONNULL_BEGIN

@interface SFPBasePlugin : NSObject

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar channelName:(NSString *)channelName class:(Class)class;

@property (nonatomic, strong, readonly) FlutterMethodChannel *methodChannel;

+ (void)registerWithMethodCall:(FlutterMethodCall *)call resp:(FlutterResult)resp;

+ (void)respError:(ANBFlutterErrorCode)error resp:(FlutterResult)resp;

@end

NS_ASSUME_NONNULL_END
