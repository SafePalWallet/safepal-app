//

#import "SFPHelper.h"

#include <math.h>

@implementation SFPHelper

+ (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)isBigScreen {
    static dispatch_once_t onceToken;
    static BOOL big;
    dispatch_once(&onceToken, ^{
        CGSize size = [self screenSize];
        big = size.width >= 375;
    });
    return big;
}

+ (uint64_t)Gwei1ETH {
    return 1000000000LL;
}

+ (uint64_t)Wei1ETH {
    return 1000000000000000000LL;
}
+ (uint64_t)satoshi1BTC {
    return 100000000LL;
}

+ (NSString *)formatDate:(NSDate *)date {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormater = nil;
    dispatch_once(&onceToken, ^{
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return [dateFormater stringFromDate:date];
}

+ (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *shortVersion = infoDic[@"CFBundleShortVersionString"];
    return shortVersion;
}

+ (NSString *)appName {
    NSString *name;
    name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return name;
}

+ (NSString *)version {
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return appVersionString;
}

+ (NSAttributedString *)progressAttrWithCur:(NSInteger)cur total:(NSInteger)total {
    NSDictionary *highlightedDic = @{NSForegroundColorAttributeName : [SFPColor greenTextColor]};
    NSDictionary *normalDic = @{NSForegroundColorAttributeName : [SFPColor greenTextColor]};
    NSMutableAttributedString *mixed = [[NSMutableAttributedString alloc] init];
    NSString *string = [NSString stringWithFormat:@"%@", @(cur)];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:string attributes:highlightedDic];
    [mixed appendAttributedString:attr];
    string = [NSString stringWithFormat:@" / %@", @(total)];
    attr = [[NSAttributedString alloc] initWithString:string attributes:normalDic];
    [mixed appendAttributedString:attr];
    return mixed.copy;
}

+ (NSDecimalNumber *)decimalNumberWithScale:(NSInteger)scale {
    NSString *text;
    switch (scale) {
        case 0:
            text = @"1";
            break;
        case 1:
            text = @"10";
            break;
        case 2:
            text = @"100";
            break;
        case 3:
            text = @"1000";
            break;
        case 4:
            text = @"10000";
            break;
        case 5:
            text = @"100000";
            break;
        case 6:
            text = @"1000000";
            break;
        case 7:
            text = @"10000000";
            break;
        case 8:
            text = @"100000000";
            break;
        case 9:
            text = @"1000000000";
            break;
        case 10:
            text = @"10000000000";
            break;
        case 11:
            text = @"100000000000";
            break;
        case 12:
            text = @"1000000000000";
            break;
        case 13:
            text = @"10000000000000";
            break;
        case 14:
            text = @"100000000000000";
            break;
        case 15:
            text = @"100000000000000";
            break;
        case 16:
            text = @"100000000000000";
            break;
        case 17:
            text = @"100000000000000";
            break;
        case 18:
            text = @"100000000000000";
            break;
        default:
            break;
    }
    if (text) {
        return [NSDecimalNumber decimalNumberWithString:text];
    }
    return nil;
}


@end
