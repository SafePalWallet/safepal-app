#import "FluttertoastPlugin.h"

#import "MBProgressHUD.h"

static NSString *const CHANNEL_NAME = @"PonnamKarthik/fluttertoast";

@interface FluttertoastPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@property(nonatomic, strong) MBProgressHUD *hud;
@end

@implementation FluttertoastPlugin {
    FlutterResult _result;
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:CHANNEL_NAME
                  binaryMessenger:[registrar messenger]];
    FluttertoastPlugin *instance = [[FluttertoastPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (UIColor*) colorWithHex: (NSUInteger)hex {
    CGFloat red, green, blue, alpha;

    red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
    green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
    blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
    alpha = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;

    return [UIColor colorWithRed: red green:green blue:blue alpha:alpha];
}

- (void)hideHUD {
    if (self.hud) {
        [self.hud hideAnimated:TRUE afterDelay:0];
    }
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if([@"cancel" isEqualToString:call.method]) {
        [self hideHUD];
        result([NSNumber numberWithBool:true]);
    } else if ([@"showToast" isEqualToString:call.method]) {
        NSString *msg = call.arguments[@"msg"];
        self.hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.detailsLabel.text = msg;
        self.hud.detailsLabel.font = [UIFont systemFontOfSize:14.0];
        [self.hud hideAnimated:YES afterDelay:1.8f];
        self.hud.userInteractionEnabled = NO;
        result([NSNumber numberWithBool:true]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - read the key window

- (UIWindow *)_readKeyWindow {
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        if ([window isKindOfClass:UIWindow.class] && window.isKeyWindow && window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    }
    return nil;
}

@end
