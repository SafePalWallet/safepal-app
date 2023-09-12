

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface AppTheme : NSObject

@property (nonatomic, strong) UIColor *mainBg;
@property (nonatomic, strong) UIColor *mainText;

+ (instancetype)instance;

@end

NS_ASSUME_NONNULL_END
