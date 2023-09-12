

#import <UIKit/UIKit.h>

@interface SFPQRCodeGenerateManager : NSObject

+ (UIImage *)generateWithDefaultQRCodeData:(NSData *)data imageViewWidth:(CGFloat)imageViewWidth;

+ (UIImage *)generateWithDefaultQRCodeData:(NSData *)data
                            imageViewWidth:(CGFloat)imageViewWidth
                                      icon:(UIImage *)icon;

+ (UIImage *)generateWithLogoQRCodeData:(NSData *)data
                          logoImageName:(NSString *)logoImageName
                   logoScaleToSuperView:(CGFloat)logoScaleToSuperView;

+ (UIImage *)generateWithColorQRCodeData:(NSData *)data
                         backgroundColor:(CIColor *)backgroundColor
                               mainColor:(CIColor *)mainColor;

@end
