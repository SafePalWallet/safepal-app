

#import "SFPQRCodeScanningVC.h"

#import "SFPQRCodeScanConfig.h"

@interface SFPQRCodeScanningVC (SFPAdd)

+ (instancetype)showScanQRAndDecodeWithConfig:(SFPQRCodeScanConfig *)config;

@end
