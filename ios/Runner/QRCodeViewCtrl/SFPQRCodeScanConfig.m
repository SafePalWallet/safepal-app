
#import "SFPQRCodeScanConfig.h"

@implementation SFPQRCodeScanConfig

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _showProgress = YES;
    _showGuideTips = YES;
    
    return self;
}

@end
