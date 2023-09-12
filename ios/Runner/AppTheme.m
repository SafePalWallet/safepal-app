

#import "AppTheme.h"

@import YYCategories;

@implementation AppTheme

+ (instancetype)instance {
    static AppTheme *theme;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        theme = [[AppTheme alloc] init];
        theme.mainBg = [UIColor colorWithHexString:@"000000"];
        theme.mainText = [UIColor colorWithHexString:@"FFFFFF"];
    });
    
    return theme;
}

@end
