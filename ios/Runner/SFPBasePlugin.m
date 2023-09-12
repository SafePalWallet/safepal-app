
#import "SFPBasePlugin.h"

@interface SFPBasePlugin ()

@property (nonatomic, strong, readwrite) FlutterMethodChannel *methodChannel;

@end

@implementation SFPBasePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar channelName:(NSString *)channelName class:(Class)class  {
    FlutterMethodChannel *methodChannel =
    [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:[registrar messenger]];
    SFPBasePlugin *instance;
    if ([class isSubclassOfClass:[SFPBasePlugin class]]) {
        instance = [[class alloc] init];
    }
    instance.methodChannel = methodChannel;
    [registrar addMethodCallDelegate:instance channel:methodChannel];
}

+ (void)registerWithMethodCall:(FlutterMethodCall *)call resp:(FlutterResult)resp {
    
}

+ (void)respError:(ANBFlutterErrorCode)errorCode resp:(FlutterResult)resp {
    id error;
    switch (errorCode) {
        case ANBFlutterErrorCodeNotImplement:
            error = FlutterMethodNotImplemented;
            break;
        case ANBFlutterErrorCodeParasInvalid:
            error = [self errorParasInvalid];
            break;
        default:
            NSAssert(NO, @"unkown error code");
            break;
    }
    resp ? resp(error) : NULL;
}

+ (void)notImplementedResp:(FlutterResult)resp {
    if (resp) {
        resp(FlutterMethodNotImplemented);
    }
}

+ (FlutterError *)errorParasInvalid {
    NSString *code = [NSString stringWithFormat:@"%@", @(ANBFlutterErrorCodeParasInvalid)];
    static FlutterError *error;
    if (!error) {
        error = [FlutterError errorWithCode:code message:@"invalid paras" details:nil];
    }
    return error;
}


@end
