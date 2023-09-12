
#import <Foundation/Foundation.h>

typedef NS_ENUM(char, SFPQRCodeFlag) {
    SFPQRCodeFlagNone = 0x00,      //
    SFPQRCodeFlagAES =  0x01 << 0, // aes crypto flag
    SFPQRCodeFlagTime = 0x01 << 1, // have time flag
    SFPQRCodeFlagBase64 = 0x01 << 2,
    SFPQRCodeFlagAll = SFPQRCodeFlagAES | SFPQRCodeFlagTime | SFPQRCodeFlagBase64
};


@interface SFPQRCodeSession : NSObject


- (instancetype)initWithMessageType:(NSInteger)msgType base64Encode:(BOOL)base64Encode aesFlag:(BOOL)aesFlag data:(NSData *)data clientId:(int)clientId secKey:(NSData *)key version:(int)version exHeader:(NSData *)exHeader;

@property (nonatomic, assign) int messageType;

@property (nonatomic, assign) NSInteger totalPacketCount; // total packet count

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSData *extHeader;

@property (nonatomic, assign) BOOL commonQR; // qr code type

@property (nonatomic, assign) int errorCode;

- (NSData *)dataForPageIndex:(NSInteger)pageIndex;

@end
