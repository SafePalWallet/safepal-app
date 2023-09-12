
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UINavigationController;
@class SFPQRCodeSession;
@class SFPQRCodeScanningVC;

typedef void(^SFPQRCodeMessageSuccessBlock)(SFPQRCodeScanningVC * _Nullable vc, SFPQRCodeSession * _Nullable session);
typedef void(^SFPQRCodeMessageFailedBlock)(void);
typedef void(^SFPQRCodeMessageCancelBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface SFPQRCodeScanConfig : NSObject

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) BOOL showGuideTips;
@property (nonatomic, assign) BOOL showNavBar;

@property (nonatomic, copy) NSString *guideTips;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iosCameraPermissionsTips;

@property (nonatomic, strong) NSString *scan_photo_error;
@property (nonatomic, strong) NSString *no_photo_permission;
@property (nonatomic, strong) NSString *ok;

@property (nonatomic, weak) UIViewController *fromViewController;

@property (nonatomic, copy) SFPQRCodeMessageSuccessBlock successHandler;
@property (nonatomic, copy) SFPQRCodeMessageFailedBlock failedHandler;
@property (nonatomic, copy) SFPQRCodeMessageCancelBlock cancelHandler;


@property (nonatomic, assign) NSInteger clientId;
@property (nonatomic, strong) NSData *key;

@end

NS_ASSUME_NONNULL_END
