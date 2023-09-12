

#import "SFPQRCodeScanView.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "SFPHelper.h"
#import <sys/utsname.h>

@interface SFPQRCodeScanView()

@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *scanningline;

@property (nonatomic, assign, readwrite) CGRect scanContentRect;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) BOOL showGuideTips;

@end

@implementation SFPQRCodeScanView

- (instancetype)initWithFrame:(CGRect)frame showGuideTips:(BOOL)showGuideTips {
    _showGuideTips = showGuideTips;
    self = [self initWithFrame:frame];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initialization];
            
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        struct utsname systemInfo;
         uname(&systemInfo);
        NSString * phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
        CGFloat factor = 0.7;
        CGFloat width = self.frame.size.width * factor;
        CGFloat height = width;
        
        if ([phoneType isEqualToString:@"iPhone15,2"] ||
            [phoneType isEqualToString:@"iPhone14,2"]) {
            width = 175;
        } else if ([phoneType isEqualToString:@"iPhone13,4"] ||
                   [phoneType isEqualToString:@"iPhone14,3"] ||
                   [phoneType isEqualToString:@"iPhone15,3"]) {
            width = 175;
        }
        height = width;
        
        CGFloat originX = (self.frame.size.width - width) / 2.0;
        CGFloat originY = (self.frame.size.height - height) / 2.0 - 60;
        _contentView.frame = CGRectMake(originX, originY, width, height);
        
        if (_showGuideTips) {
            _progressLabel = [UILabel new];
            _progressLabel.font = [UIFont systemFontOfSize:15];
            _progressLabel.textColor = [UIColor whiteColor];
            [self addSubview:_progressLabel];
            [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView.mas_bottom).with.offset(5);
            }];
            
            _bgView = [UIView new];
            [self addSubview:_bgView];
            [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self);
                if (@available(iOS 11, *)) {
                    make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
                } else {
                    make.bottom.equalTo(self.mas_bottom);
                }
                make.top.equalTo(self.progressLabel.mas_bottom);
            }];
        }
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
}

- (void)initialization {
    _scanningAnimationStyle = ScanningAnimationStyleDefault;
    _borderColor = [SFPColor whiteLightTextColor];
    _cornerLocation = CornerLoactionDefault;
    _cornerColor = [SFPColor greenTextColor];
    _cornerWidth = 2.0;
    _backgroundAlpha = 0.5;
    _animationTimeInterval = 0.02;
    _scanningImageName = @"Sscanning_line";
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat borderW = self.contentView.bounds.size.width;
    CGFloat borderH = self.contentView.bounds.size.height;
    CGFloat borderX = self.contentView.frame.origin.x;
    CGFloat borderY = self.contentView.frame.origin.y;
    self.scanContentRect = CGRectMake(borderX, borderY, borderW, borderH);
    if (self.scanContectRectDidChangeBlock) {
        self.scanContectRectDidChangeBlock();
    }
    CGFloat borderLineW = 0.2;
    [[[UIColor blackColor] colorWithAlphaComponent:self.backgroundAlpha] setFill];
    UIRectFill(rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX + 0.5 * borderLineW, borderY + 0.5 *borderLineW, borderW - borderLineW, borderH - borderLineW)];
    [bezierPath fill];
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX, borderY, borderW, borderH)];
    borderPath.lineCapStyle = kCGLineCapButt;
    borderPath.lineWidth = borderLineW;
    [self.borderColor set];
    [borderPath stroke];
    
    CGFloat cornerLenght = 20;
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    leftTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    CGFloat insideExcess = fabs(0.5 * (self.cornerWidth - borderLineW));
    CGFloat outsideExcess = 0.5 * (borderLineW + self.cornerWidth);
    if (self.cornerLocation == CornerLoactionInside) {
        [leftTopPath moveToPoint:CGPointMake(borderX + insideExcess, borderY + cornerLenght + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght + insideExcess, borderY + insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [leftTopPath moveToPoint:CGPointMake(borderX - outsideExcess, borderY + cornerLenght - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght - outsideExcess, borderY - outsideExcess)];
    } else {
        [leftTopPath moveToPoint:CGPointMake(borderX, borderY + cornerLenght)];
        [leftTopPath addLineToPoint:CGPointMake(borderX, borderY)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght, borderY)];
    }
    
    [leftTopPath stroke];
    
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    leftBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - cornerLenght - insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH - cornerLenght + outsideExcess)];
    } else {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH - cornerLenght)];
    }
    
    [leftBottomPath stroke];
    
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    rightTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + cornerLenght + insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + cornerLenght - outsideExcess)];
    } else {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY + cornerLenght)];
    }
    
    [rightTopPath stroke];
    
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    rightBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - cornerLenght - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght - insideExcess, borderY + borderH - insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH - cornerLenght + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght + outsideExcess, borderY + borderH + outsideExcess)];
    } else {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW, borderY + borderH - cornerLenght)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW, borderY + borderH)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght, borderY + borderH)];
    }
    
    [rightBottomPath stroke];
}

#pragma mark - - - timer
- (void)addTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    CGFloat scanninglineX = 0;
    CGFloat scanninglineY = 0;
    CGFloat scanninglineW = 0;
    CGFloat scanninglineH = 0;
    
    CGFloat scanBorderW = self.contentView.bounds.size.width;
    CGFloat scanBorderX = self.contentView.frame.origin.x;
    CGFloat scanBorderY = self.contentView.frame.origin.y;
    
    if (self.scanningAnimationStyle == ScanningAnimationStyleGrid) {
        [self addSubview:self.contentView];
        [_contentView addSubview:self.scanningline];
        scanninglineW = scanBorderW;
        scanninglineH = scanBorderW;
        scanninglineX = 0;
        scanninglineY = - scanBorderW;
        _scanningline.frame = CGRectMake(scanninglineX, scanninglineY, scanninglineW, scanninglineH);
    } else {
        [self addSubview:self.scanningline];
        
        scanninglineW = scanBorderW;
        scanninglineH = 12;
        scanninglineX = scanBorderX;
        scanninglineY = scanBorderY;
        _scanningline.frame = CGRectMake(scanninglineX, scanninglineY, scanninglineW, scanninglineH);
    }
    self.timer = [NSTimer timerWithTimeInterval:self.animationTimeInterval target:self selector:@selector(beginRefreshUI) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.scanningline removeFromSuperview];
    self.scanningline = nil;
}


- (void)beginRefreshUI {
    __block CGRect frame = _scanningline.frame;
    static BOOL flag = YES;
    CGFloat scanBorderW = self.contentView.bounds.size.width;
    CGFloat scanBorderX = self.contentView.frame.origin.x;
    CGFloat scanBorderY = self.contentView.frame.origin.y;
    @weakify(self);
    if (self.scanningAnimationStyle == ScanningAnimationStyleGrid) {
        if (flag) {
            frame.origin.y = - scanBorderW;
            flag = NO;
            [UIView animateWithDuration:self.animationTimeInterval animations:^{
                @strongify(self);
                frame.origin.y += 2;
                _scanningline.frame = frame;
            } completion:nil];
        } else {
            if (_scanningline.frame.origin.y >= - scanBorderW) {
                CGFloat scanContent_MaxY = - scanBorderW + self.frame.size.width - 2 * scanBorderX;
                if (_scanningline.frame.origin.y >= scanContent_MaxY) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        @strongify(self);
                        frame.origin.y = - scanBorderW;
                        _scanningline.frame = frame;
                        flag = YES;
                    });
                } else {
                    [UIView animateWithDuration:self.animationTimeInterval animations:^{
                        @strongify(self);
                        frame.origin.y += 2;
                        _scanningline.frame = frame;
                    } completion:nil];
                }
            } else {
                flag = !flag;
            }
        }
    } else {
        if (flag) {
            frame.origin.y = scanBorderY;
            flag = NO;
            [UIView animateWithDuration:self.animationTimeInterval animations:^{
                @strongify(self);
                frame.origin.y += 2;
                _scanningline.frame = frame;
            } completion:nil];
        } else {
            if (_scanningline.frame.origin.y >= scanBorderY) {
                CGFloat scanContent_MaxY = scanBorderY + self.frame.size.width - 2 * scanBorderX;
                if (_scanningline.frame.origin.y >= scanContent_MaxY - 10) {
                    frame.origin.y = scanBorderY;
                    _scanningline.frame = frame;
                    flag = YES;
                } else {
                    [UIView animateWithDuration:self.animationTimeInterval animations:^{
                        @strongify(self);
                        frame.origin.y += 2;
                        _scanningline.frame = frame;
                    } completion:nil];
                }
            } else {
                flag = !flag;
            }
        }
    }
}

- (UIImageView *)scanningline {
    if (!_scanningline) {
        _scanningline = [[UIImageView alloc] init];
        _scanningline.image = [[UIImage imageNamed:self.scanningImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _scanningline.tintColor = [SFPColor greenTextColor];
    }
    return _scanningline;
}

#pragma mark - - - set
- (void)setScanningAnimationStyle:(ScanningAnimationStyle)scanningAnimationStyle {
    _scanningAnimationStyle = scanningAnimationStyle;
}

- (void)setScanningImageName:(NSString *)scanningImageName {
    _scanningImageName = scanningImageName;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
}

- (void)setCornerLocation:(CornerLoaction)cornerLocation {
    _cornerLocation = cornerLocation;
}

- (void)setCornerColor:(UIColor *)cornerColor {
    _cornerColor = cornerColor;
}

- (void)setCornerWidth:(CGFloat)cornerWidth {
    _cornerWidth = cornerWidth;
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    _backgroundAlpha = backgroundAlpha;
}

- (void)setAnimationTimeInterval:(NSTimeInterval)animationTimeInterval {
    _animationTimeInterval = animationTimeInterval;
}

@end
