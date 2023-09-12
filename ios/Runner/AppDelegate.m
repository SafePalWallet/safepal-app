#import "AppDelegate.h"

#import <Flutter/Flutter.h>
#import <YYCategories/YYCategories.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "GeneratedPluginRegistrant.h"
#import "SFPHelper.h"
#import "SFPQRCodeScanningVC.h"
#import "SFPBaseNavigationController.h"
#import "SFPQRCodeGenerateManager.h"

#import "SFPCryptoPlugin.h"
#import "SFPQRPlugin.h"
#import "SFPUtilsPlugin.h"
#import "SFPFlutterBaseViewController.h"
#import "MBProgressHUD.h"
#import "FluttertoastPlugin.h"
#import "AppTheme.h"

static NSString *FlutterQRKey = @"flutter.safepal.io/qr";
static NSString *FlutterCryptoKey = @"flutter.safepal.io/crypto";
static NSString *FlutterUtilsKey = @"flutter.safepal.io/util";
static NSString *FlutterHUDProgressKey = @"flutter.safepal.io/HUDProgress";

@interface AppDelegate () {
    int count;
}

@property (nonatomic, strong) FlutterMethodChannel *qrChannel;
@property (nonatomic, strong) FlutterMethodChannel *cryptoChannel;
@property (nonatomic, strong) FlutterMethodChannel *utilChannel;
@property (nonatomic, strong) FlutterMethodChannel *hudProgressChannel;

@property (nonatomic, strong) MBProgressHUD *hud;

@property(strong, nonatomic) NSTimer *mTimer;
@property(assign, nonatomic) UIBackgroundTaskIdentifier backIden;

@property (assign, nonatomic) BOOL isDark;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [FluttertoastPlugin registerWithRegistrar:[self registrarForPlugin:@"FluttertoastPlugin"]];
    
    [self globalConfigNavigationBar];
    
    SFPFlutterBaseViewController *controller = (SFPFlutterBaseViewController *)(self.window.rootViewController);
    [self registerPlatformChannelWithController:controller];
    
    return YES;
}

- (void)registerPlatformChannelWithController:(FlutterViewController *)controller {
    @weakify(self);
    self.cryptoChannel = [FlutterMethodChannel methodChannelWithName:FlutterCryptoKey binaryMessenger:controller];
    [self.cryptoChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [SFPCryptoPlugin registerWithMethodCall:call resp:result];
    }];
    
    self.qrChannel =[FlutterMethodChannel methodChannelWithName:FlutterQRKey binaryMessenger:controller];
    [self.qrChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [SFPQRPlugin registerWithMethodCall:call resp:result];
    }];
    
    self.utilChannel = [FlutterMethodChannel methodChannelWithName:FlutterUtilsKey binaryMessenger:controller];
    [self.utilChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [SFPUtilsPlugin registerWithMethodCall:call resp:result];
    }];
    
    self.hudProgressChannel = [FlutterMethodChannel methodChannelWithName:FlutterHUDProgressKey binaryMessenger:controller];
    [self.hudProgressChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        @strongify(self);
        [self handlerHudChannel:call result:result];
    }];
}

- (void)showViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [rootVC presentViewController:nav animated:YES completion:NULL];
}


- (void)handlerHudChannel:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"show"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *paras = call.arguments;
            NSString *message = paras[@"message"];
            BOOL autoHide = TRUE;
            if ([paras.allKeys containsObject:@"auto_hide"]) {
                autoHide = [paras[@"auto_hide"] boolValue];
            }
            if (self.hud != NULL) {
                [self.hud hideAnimated:NO];
            }
            self.hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            self.hud.mode = MBProgressHUDModeIndeterminate;
            if (message) {
                self.hud.label.text = message;
            }
            if (autoHide) {
                [self.hud hideAnimated:YES afterDelay:2.5];
            }
            if (result) {
                result([NSNumber numberWithBool:TRUE]);
            }
        });
    } else if ([call.method isEqualToString:@"dismiss"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES];
            self.hud = NULL;
            if (result) {
                result([NSNumber numberWithBool:TRUE]);
            }
        });
    } else if ([call.method isEqualToString:@"isShow"]) {
        BOOL isShow = NO;
        if (self.hud) {
            isShow = TRUE;
        }
        if (result) {
            result([NSNumber numberWithBool:isShow]);
        }
    } else {
        if (result) {
            result(FlutterMethodNotImplemented);
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)globalConfigNavigationBar {
    UINavigationBar *appearance = [UINavigationBar appearance];
    appearance.shadowImage = [UIImage new];
    appearance.backgroundColor = AppTheme.instance.mainBg;
    appearance.barTintColor = AppTheme.instance.mainBg;
    appearance.tintColor = AppTheme.instance.mainBg;
    appearance.translucent = NO;
    [appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : AppTheme.instance.mainText,
       NSFontAttributeName : [SFPFont topTitleFontBold]}];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
        barAppearance.backgroundColor = AppTheme.instance.mainBg;
        barAppearance.shadowImage = [UIImage new];
        barAppearance.shadowColor = nil;
        [barAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName : AppTheme.instance.mainText,
                                                NSFontAttributeName : [SFPFont topTitleFontBold]}];
        appearance.standardAppearance = barAppearance;
        appearance.scrollEdgeAppearance = barAppearance;
    }
}


@end
