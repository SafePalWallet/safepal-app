
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CornerLoactionDefault,
    CornerLoactionInside,
    CornerLoactionOutside
} CornerLoaction;

typedef enum : NSUInteger {
    ScanningAnimationStyleDefault,
    ScanningAnimationStyleGrid
} ScanningAnimationStyle;

@interface SFPQRCodeScanView : UIView

- (instancetype)initWithFrame:(CGRect)frame showGuideTips:(BOOL)showGuideTips;

@property (nonatomic, assign) ScanningAnimationStyle scanningAnimationStyle;
@property (nonatomic, copy) NSString *scanningImageName;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CornerLoaction cornerLocation;
@property (nonatomic, strong) UIColor *cornerColor;
@property (nonatomic, assign) CGFloat cornerWidth;
@property (nonatomic, assign) CGFloat backgroundAlpha;
@property (nonatomic, assign) NSTimeInterval animationTimeInterval;
@property (nonatomic, assign, readonly) CGRect scanContentRect;
@property (nonatomic, copy) void(^scanContectRectDidChangeBlock)(void);
@property (nonatomic, strong, readonly) UIView *contentView;


- (void)addTimer;
- (void)removeTimer;

@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, strong) UILabel *guideTipsLabel;
@property (nonatomic, strong) UILabel *progressLabel;


@end
