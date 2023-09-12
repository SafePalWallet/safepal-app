//

#import <WebKit/WKWebView.h>
#import <WebKit/WKWebsiteDataStore.h>
#import <YYCategories/YYCategories.h>
#include <sys/sysctl.h>
#import "SFPUtilsPlugin.h"
#import <UserNotifications/UserNotifications.h>

#import "AppDelegate.h"
#import "SFPMacro.h"
#import "AppTheme.h"

@import UIKit;

static FlutterResult saveImageResp;

static NSString *copyMethodName = @"copy";
static NSString *pasteMethodName = @"paste";
static NSString *openBrowerMethodName = @"openBrower";

@implementation SFPUtilsPlugin

+ (void)registerWithMethodCall:(FlutterMethodCall *)call resp:(FlutterResult)resp {
    if ([call.method isEqualToString:copyMethodName]) {
        NSString *text = call.arguments;
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:text];
        if (resp) {
            resp([NSNumber numberWithBool:YES]);
        }
    } else if ([call.method isEqualToString:pasteMethodName]) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        if (resp) {
            resp([pb string]);
        }
    } else if ([call.method isEqualToString:openBrowerMethodName]) {
        NSString *url = call.arguments;
        BOOL result = NO;
        if ([url isKindOfClass:[NSString class]]) {
            NSURL *URL = [NSURL URLWithString:url];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
                result = YES;
            } else {
                result = NO;
            }
        }
        if (resp) {
            resp([NSNumber numberWithBool:result]);
        }
    }else {
        [self respError:ANBFlutterErrorCodeNotImplement resp:resp];
    }
}

@end
