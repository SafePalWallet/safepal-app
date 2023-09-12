
#import "SFPQRCodeSession.h"

#import <YYCategories/YYCategories.h>

#include "qr_pack.h"
#include "SFPMacro.h"


static int const kPacketSize = 250;

@interface SFPQRCodeSession()

@property (nonatomic, assign) NSInteger msgType;
@property (nonatomic, strong) NSData *key;

@end

@implementation SFPQRCodeSession {
    qr_packet_chunk_info *_chunk_info;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _errorCode = 0;
    
    return self;
}

- (instancetype)initWithMessageType:(NSInteger)msgType
                       base64Encode:(BOOL)base64Encode
                            aesFlag:(BOOL)aesFlag
                               data:(NSData *)data
                           clientId:(int)clientId
                             secKey:(NSData *)key
                            version:(int)version
                           exHeader:(NSData *)exHeader
{
    self = [self init];
    if (!self) {
        return nil;
    }
    
    _msgType = msgType;
    _key = key;
    
    // time 4 bytes + 2 time zone
    NSMutableData *newData = [[NSMutableData alloc] initWithCapacity:data.length + 6];
    NSDate *date = [NSDate date];

    
    uint32_t time = (uint32_t)[date timeIntervalSince1970];
    
    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    NSInteger offsetTimeS = 0;
    offsetTimeS = [systemTimeZone secondsFromGMTForDate:date];
    NSInteger tempZone = (offsetTimeS / 60); // minute
    int16_t zone = (int16_t)tempZone;
    zone = ((zone&0xff) << 8) | ((zone >>8) & 0xff);
    if (version <= 10009) {
        zone = 0;
        time += offsetTimeS;
    }
    NSData *zoneData = [NSData dataWithBytes:&zone length:sizeof(uint16_t)];
    
    time = htonl(time);
    NSData *timeData = [NSData dataWithBytes:&time length:sizeof(uint32_t)];
    
    [newData appendData:timeData];
    [newData appendData:zoneData];
    if (exHeader != NULL){
        [newData appendData:exHeader];
    }
    [newData appendData:data];
    
    _data = [newData copy];
    
    int flag = 0;
    if (aesFlag) {
        flag |= QR_FLAG_CRYPT_AES;
    }
    flag |= QR_FLAG_HAS_TIME;
    if (exHeader != NULL) {
        flag |= QR_FLAG_EXT_HEADER;
    }
    
    int qrType = QR_TYPE_BIN;
    if (base64Encode) {
        qrType = QR_TYPE_B64;
    }
    
    qr_packet_chunk_info *chunk_info = (qr_packet_chunk_info *)malloc(sizeof(qr_packet_chunk_info));
    _chunk_info = chunk_info;
    memset(_chunk_info, 0, sizeof(qr_packet_chunk_info));
    
    split_qr_packet(_chunk_info,
                    (const unsigned char *)_data.bytes,
                    (int)_data.length,
                    qrType,
                    (int)self.msgType,
                    flag,
                    clientId,
                    (const unsigned char *)key.bytes,
                    kPacketSize);
    
    _totalPacketCount = _chunk_info->total;
    
    return self;
}

- (void)dealloc {
    if (_chunk_info) {
        memset(_chunk_info, 0, sizeof(qr_packet_chunk_info));
        free_qr_packet_chunk(_chunk_info);
        free(_chunk_info);
    }
}

- (NSData *)dataForPageIndex:(NSInteger)pageIndex {
    if (index < 0 || !self.data || pageIndex >= self.totalPacketCount) {
        return nil;
    }
    qr_packet_chunk_slice *slice = (qr_packet_chunk_slice *)(_chunk_info->chunks + pageIndex);
    NSData *data = [NSData dataWithBytes:slice->data length:slice->size];
    
    return data;
}

@end
