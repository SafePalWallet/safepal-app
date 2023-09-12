
#import <UIKit/UIKit.h>
#import "SFPQRCodeScanConfig.h"
#import "SFPQRCodeSession.h"

@class SFPQRCodeScanningVC;

typedef void(^ANBQRCodeScanCompleteBlock)(SFPQRCodeScanningVC *vc, BOOL commonQR, NSData *data);
typedef void(^ANBQRCodeScanCancelBlock)(void);

@interface SFPQRCodeScanningVC : UIViewController

- (instancetype)initWithConfig:(SFPQRCodeScanConfig *)config;

+ (SFPQRCodeScanningVC *)showQRCodeScanVCWithConfig:(SFPQRCodeScanConfig *)config;

@property (nonatomic, copy) ANBQRCodeScanCompleteBlock completeBlock;
@property (nonatomic, copy) ANBQRCodeScanCancelBlock cancelBlock;

- (void)startScan;
- (void)stopScan;

- (void)updateIndex:(NSInteger)index total:(NSInteger)total;

- (void)playVibrate;

@end

#import "SFPQRCodeScanningVC+SFPAdd.h"
