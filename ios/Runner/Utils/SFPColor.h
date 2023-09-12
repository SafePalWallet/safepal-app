//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFPColor : NSObject

+ (UIColor *)globalBgColor;
+ (UIColor *)normalColor;

+ (UIColor *)cardNormalBgColor;
+ (UIColor *)cardSelectedColor;

+ (UIColor *)warningStateColor;
+ (UIColor *)normalStateColor;

//==============================
+ (UIColor *)blueBgColor;

+ (UIColor *)grayBgColor;
+ (UIColor *)transparentDarkBgColor;
+ (UIColor *)whiteLightBgColor;
+ (UIColor *)darkBlackBgColor;

+ (UIColor *)grayInWhiteBgColor;

// text color
+ (UIColor *)darkBlackTextColor;
+ (UIColor *)grayTextColor;
+ (UIColor *)blueTextColor;
+ (UIColor *)greenTextColor;
+ (UIColor *)whiteLightTextColor;
+ (UIColor *)disableTextColor;


// image tint color
+ (UIColor *)whiteImageTintColor;
+ (UIColor *)backDarkImageTintColor;

+ (UIColor *)tabNormalColor;
+ (UIColor *)tabSelectedColor;
+ (UIColor *)tabbarBgColor;


+ (UIColor *)colorWithString:(NSString *)s opacity:(CGFloat)opacity;

+ (UIColor *)debugColor;


@end
