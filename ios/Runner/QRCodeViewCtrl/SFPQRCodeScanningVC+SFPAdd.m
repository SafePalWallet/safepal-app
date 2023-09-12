

#import "SFPQRCodeScanningVC+SFPAdd.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <YYCategories/YYCategories.h>

#import "SFPQRCodeSession.h"
#include "qr_pack.h"
#include "SFPMacro.h"
#include "wallet_proto_qr.h"

static qr_packet _qr;
static qr_packet_buffer _buffer;

@implementation SFPQRCodeScanningVC (SFPAdd)

+ (instancetype)showScanQRAndDecodeWithConfig:(SFPQRCodeScanConfig *)config {
    init_qr_packet(&_qr, 0);
    memset(&_buffer, 0, sizeof(qr_packet_buffer));
    SFPQRCodeScanningVC *scanVC = [self showQRCodeScanVCWithConfig:config];
    [scanVC setCancelBlock:^{
        if (config.cancelHandler) {
            config.cancelHandler();
        }
    }];
    __weak typeof(scanVC) weakVC = scanVC;
    [scanVC setCompleteBlock:^(SFPQRCodeScanningVC *vc, BOOL commonQR, NSData *data) {
        SFPQRCodeSession *session = [[SFPQRCodeSession alloc] init];
        session.messageType = 0;
        if (commonQR) {
            if (config.successHandler) {
                session.data = data;
                session.commonQR = YES;
                config.successHandler(vc, session);
            }
            return ;
        }
        
        qr_packet *qr = &_qr;
        qr_packet_buffer *buffer = &_buffer;
        int result = merge_qr_packet_buffer(buffer, qr, (const char *)data.bytes, (size_t)data.length);
        CGFloat progress = (qr->p_index + 1) / (CGFloat)(qr->p_total);
        DMLog(@"index:%d total:%d progress:%f result:%d", qr->p_index + 1, qr->p_total, progress, result);
#ifdef DEBUG
        NSMutableArray *idxRets = [[NSMutableArray alloc] init];
        for (int idx = 0; idx < qr->p_total; idx++) {
            if (buffer && buffer->chunks[idx]) {
                [idxRets addObject:@(idx)];
            }
        }
        NSData *retsData = [NSJSONSerialization dataWithJSONObject:idxRets options:NSJSONWritingFragmentsAllowed error:NULL];
        DMLog(@"scan index result:%@", [[NSString alloc] initWithData:retsData encoding:NSUTF8StringEncoding]);
#endif
        if (result < 0) {
            DMLog(@"merge failed result:%d", result);
            free_qr_buffer(buffer);
            free_qr_packet(qr);
            session.errorCode = result;
            if (config.successHandler) {
                config.successHandler(vc, session);
            }
            return;
        }
        [weakVC updateIndex:qr->p_index + 1 total:qr->p_total];
        if (result == QR_DECODE_SUCCESS) {
            [weakVC stopScan];
            
            if (qr->flag & QR_FLAG_CRYPT_AES) {
                NSData *aes = config.key;
                unsigned char *aesBuf = (unsigned char *)malloc(aes.length);
                if (!aesBuf) {
                    session.errorCode = QR_DECODE_SYSTEM_ERR;
                } else {
                    memset(aesBuf, 0, aes.length);
                    [aes getBytes:(void *)aesBuf length:aes.length];
                    result = decrypt_qr_packet(qr, (const unsigned char *)aesBuf);
                    DMLog(@"decrypt result:%d", result);
                    if (verify_qr_packet(qr)) {
                        session.errorCode = QR_DECODE_INVALID_HASH_CHECK;
                    }
                    free(aesBuf);
                }
                if (session.errorCode != 0) {
                    free_qr_buffer(buffer);
                    free_qr_packet(qr);
                    init_qr_packet(qr, 0);
                    [self showAlert:weakVC tips:nil restartScan:YES];
                    if (config.successHandler) {
                        config.successHandler(weakVC, session);
                    }
                    return ;
                }
            }
            
            NSData *extHeader;
            if (qr->flag & QR_FLAG_EXT_HEADER) {
                const int len = qr_packet_ext_header_length(qr);
                if (len > 0) {
                    const unsigned char *d = qr_packet_ext_header_str(qr, len);
                    extHeader = [[NSData alloc] initWithBytes:(const void *)d length:len];
                }
            }
            
            session.messageType = qr->type;
            session.commonQR = NO;
            
            size_t dataLen = qr->data->len;
            if (qr->p_total > 1) {
                dataLen = qr->data->len - 4;
            }
            NSData *nsdataRawData = [NSData dataWithBytes:qr->data->str length:dataLen];
            session.extHeader = extHeader;
            session.data = nsdataRawData;
            session.errorCode = 0;
            free_qr_buffer(buffer);
            free_qr_packet(qr);
            init_qr_packet(qr, 0);
            DMLog(@"decrypt hex:%@", nsdataRawData.hexString);
            if (config.successHandler) {
                config.successHandler(weakVC, session);
            }
            return;
        }
    }];
    return scanVC;
}

+ (void)showAlert:(SFPQRCodeScanningVC *)vc tips:(NSString *)tips restartScan:(BOOL)restartScan {
    if (!restartScan) {
        return ;
    }
    __weak typeof (vc) weakVC = vc;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakVC startScan];
    });
}

@end
