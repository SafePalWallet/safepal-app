//

#import "SFPColor.h"

#define ANBGetColor(color, alpha)     ({ \
static id object;\
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    object = [self colorWithString:((color)) opacity:(alpha)]; \
}); \
object; \
});\



@implementation SFPColor

+ (UIColor *)globalBgColor {
    return ANBGetColor(@"#0A0F1A", 1.0);
}

+ (UIColor *)normalColor {
    return ANBGetColor(@"#505A6E", 1.0)
}

+ (UIColor *)cardNormalBgColor {
    return ANBGetColor(@"#151F36", 1.0);
}

+ (UIColor *)cardSelectedColor {
    return ANBGetColor(@"#1C2A48", 1.0);
}

+ (UIColor *)warningStateColor {
    return ANBGetColor(@"#F50605", 1.0);
}

+ (UIColor *)normalStateColor {
    return ANBGetColor(@"#39BD1E", 1.0);
}

+ (UIColor *)grayInWhiteBgColor {
    return ANBGetColor(@"#818181", 1.0);
}

// background color

+ (UIColor *)blueBgColor {
    return ANBGetColor(@"#4A21EF", 1.0);
}

+ (UIColor *)transparentDarkBgColor {
    return ANBGetColor(@"#000000", 0.7);
}

+ (UIColor *)grayBgColor {
    return ANBGetColor(@"#505A6E", 1.0);
}

+ (UIColor *)whiteLightBgColor {
    return ANBGetColor(@"#FFFFFF", 1.0);
}

+ (UIColor *)darkBlackBgColor {
    return ANBGetColor(@"#000000", 1.0);
}

// text color
+ (UIColor *)darkBlackTextColor {
    return ANBGetColor(@"#000000", 1.0);
}

+ (UIColor *)grayTextColor {
    return ANBGetColor(@"#8C94A1", 1.0);
}

+ (UIColor *)disableTextColor {
    return ANBGetColor(@"#8E8E93", 0.5);
}

+ (UIColor *)blueTextColor {
    return ANBGetColor(@"#4A21EF", 1.0);
}

+ (UIColor *)greenTextColor {
    return ANBGetColor(@"#39BD1E", 1.0);
}

+ (UIColor *)whiteLightTextColor {
    return ANBGetColor(@"#FFFFFF", 1.0);
}

// image tint color
+ (UIColor *)whiteImageTintColor {
    return ANBGetColor(@"#FFFFFF", 1.0);
}

+ (UIColor *)backDarkImageTintColor {
    return ANBGetColor(@"#000000", 1.0);
}

+ (UIColor *)tabNormalColor {
    return ANBGetColor(@"#505A6E", 1.0);
}

+ (UIColor *)tabSelectedColor {
    return [self blueBgColor];
}

+ (UIColor *)tabbarBgColor {
    return ANBGetColor(@"#151C30", 1.0);
}

#pragma -mark private method

+ (UIColor *)colorWithString:(NSString *)s {
    NSAssert(s, @"method <colorWithString:> paras cann't be nil");
    uint temp;
    if ([s hasPrefix:@"#"]) {
        [[NSScanner scannerWithString:[s substringFromIndex:1]] scanHexInt:&temp];
        temp = temp | 0xff000000;
        return [self colorWithRGB:temp];
    }
    
    NSString *errorTips = [NSString stringWithFormat:@"method <colorWithString:> paras %@ format error", s];
    NSAssert(NO, errorTips);
    
    return nil;
}

+ (UIColor *)colorWithRGB:(int)colorValue {
    int b = colorValue & 0xff;
    int g = (colorValue >> 8) & 0xff;
    int r = (colorValue >> 16) & 0xff;
    int a = (colorValue >> 24) & 0xff;
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}

+ (UIColor *)colorWithString:(NSString *)s opacity:(CGFloat)opacity {
    UIColor *color = [self colorWithString:s];
    return [color colorWithAlphaComponent:opacity];
}

+ (UIColor *)debugColor {
    return ANBGetColor(@"#FF0000", 1.0);
}

@end
