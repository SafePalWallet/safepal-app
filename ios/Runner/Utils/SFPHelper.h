//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "SFPColor.h"
#include "SFPMacro.h"
#import "SFPFont.h"

#define ANBSCREEN_WIDTH [ANBHelper screenSize].width
#define ANBSCREEN_HEIGHT [ANBHelper screenSize].height

@interface SFPHelper : NSObject

+ (CGSize)screenSize;

+ (NSString *)version;
+ (NSString *)appName;

+ (BOOL)isBigScreen;

+ (uint64_t)Gwei1ETH;
+ (uint64_t)Wei1ETH;
+ (uint64_t)satoshi1BTC;

+ (NSString *)formatDate:(NSDate *)date;

+ (NSString *)appVersion;

+ (NSAttributedString *)progressAttrWithCur:(NSInteger)cur total:(NSInteger)total;

+ (NSDecimalNumber *)decimalNumberWithScale:(NSInteger)scale;

@end
