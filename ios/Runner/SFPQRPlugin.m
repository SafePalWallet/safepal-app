//

#import "SFPQRPlugin.h"
#import "SFPQRCodeScanConfig.h"
#import "SFPQRCodeScanningVC.h"
#import "SFPQRCodeScanningVC+SFPAdd.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <YYCategories/YYCategories.h>
#import "SFPMacro.h"
#import "SFPQRCodeSession.h"
#import "SFPQRCodeGenerateManager.h"

@implementation SFPQRPlugin

+ (void)registerWithMethodCall:(FlutterMethodCall *)call resp:(FlutterResult)resp {
    if ([call.method isEqualToString:@"show_qr_scan"]) {
        [self showQRScanViewControllerCall:call resp:resp];
    } else if ([call.method isEqualToString:@"split_qr_data"]) {
        [self splitQrData:call resp:resp];
    } else {
        [self respError:ANBFlutterErrorCodeNotImplement resp:resp];
    }
}

+ (void)showQRScanViewControllerCall:(FlutterMethodCall *)call resp:(FlutterResult)resp {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSDictionary *paras = (NSDictionary *)call.arguments;
    NSData *secKey;
    if ([paras.allKeys containsObject:@"sec_key"]) {
        FlutterStandardTypedData *typedData = paras[@"sec_key"];
        secKey = typedData.data;
    }
    NSInteger clientId = 0;
    if ([paras.allKeys containsObject:@"client_id"]) {
        clientId = [paras[@"client_id"] integerValue];
    }
    SFPQRCodeScanConfig *config = [[SFPQRCodeScanConfig alloc] init];
    config.showGuideTips = [paras[@"show_guide_tips"] boolValue];
    config.showProgress = [paras[@"show_progress"] boolValue];;
    config.showNavBar = [paras[@"show_nav_bar"] boolValue];
    config.guideTips = paras[@"tips"];
    config.title = paras[@"title"];
    config.iosCameraPermissionsTips = paras[@"iosCameraPermissionsTips"];
    config.no_photo_permission = paras[@"no_photo_permission"];
    config.scan_photo_error = paras[@"scan_photo_error"];
    config.ok = paras[@"ok"];
    config.fromViewController = rootVC;
    config.key = secKey;
    config.clientId = clientId;
    SFPQRCodeScanningVC *vc = [SFPQRCodeScanningVC showScanQRAndDecodeWithConfig:config];
    @weakify(vc);
    [vc setCancelBlock:^{
        @strongify(vc);
        [vc.parentViewController dismissViewControllerAnimated:YES completion:NULL];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[NSNumber numberWithInt:1] forKey:@"cancel"];
        if (resp) {
            resp(dic.copy);
        }
    }];
    [config setSuccessHandler:^(SFPQRCodeScanningVC * _Nullable viewControlelr, SFPQRCodeSession * _Nullable session) {
        @strongify(vc);
        NSData *data = session.data;
        NSMutableDictionary *dic = [NSMutableDictionary new];
        id result;
        if (!session.commonQR) { // 二进制数据
            DMLog(@"mobile scan !commonQR result:%@", data.hexString.lowercaseString);
            if (data != nil) {
                result = [FlutterStandardTypedData typedDataWithBytes:data];
            }
        } else {
            // 字符串
            if (data != nil) {
                result = [NSString stringWithUTF8String:data.bytes];
            }
            DMLog(@"mobile scan commonQR result:%@", result);
        }
        if (result) {
            [dic setObject:result forKey:@"data"];
        }
        if (session.extHeader) {
            [dic setObject:session.extHeader forKey:@"ext_header"];
        }
        [dic setObject:@(session.messageType) forKey:@"message_type"];
        [dic setObject:@(session.errorCode) forKey:@"errorCode"];
        
        if (resp) {
            resp(dic.copy);
        }
        [vc.parentViewController dismissViewControllerAnimated:YES completion:NULL];
    }];
}

+ (void)splitQrData:(FlutterMethodCall *)call resp:(FlutterResult)resp {
    NSDictionary *paras = (NSDictionary *)call.arguments;
    CGFloat width = [paras[@"width"] floatValue];
    FlutterStandardTypedData *data = paras[@"data"];
    int clientId = (int)[paras[@"client_id"] integerValue];
    FlutterStandardTypedData *secKey = paras[@"sec_key"];
    NSInteger msg_type = [paras[@"msg_type"] integerValue];
    BOOL aesFlag = [paras[@"aes_flag"] boolValue];
    BOOL qr_type = [paras[@"qr_type"] boolValue];
    int version = (int)[paras[@"version"] integerValue];
    FlutterStandardTypedData *exHeader = paras[@"exHeader"];
    
    SFPQRCodeSession *session = [[SFPQRCodeSession alloc] initWithMessageType:msg_type base64Encode:qr_type aesFlag:aesFlag data:data.data clientId:clientId secKey:secKey.data version:version exHeader:exHeader.data];
    
    NSMutableArray *items = [NSMutableArray new];
    for (NSInteger index = 0; index < session.totalPacketCount; index++) {
        NSData *qrData = [session dataForPageIndex:index];
        FlutterStandardTypedData *flutterData = [FlutterStandardTypedData typedDataWithBytes:qrData];
        [items addObject:flutterData];
    }
    
    if (resp) {
        resp(items.copy);
    }
}

@end
