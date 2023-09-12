//

#import "SFPCryptoUtil.h"

#import <CommonCrypto/CommonDigest.h>
#import <YYCategories/YYCategories.h>
#import "SFPPubHDNode.h"
#include "SFPMacro.h"

#include "qr_pack.h"
#include "debug.h"
#include "base58.h"
#include "address.h"
#include "ecdsa.h"
#include "bip32.h"

@implementation SFPCryptoUtil

+ (NSData *)revertData:(NSData *)data {
    NSMutableData *tmpData = [[NSMutableData alloc] initWithBytes:data.bytes length:data.length];
    char *tmp = NULL;
    for (int i = 0; i < data.length; i++) {
        tmp = (char *)tmpData.bytes;
        *(tmp + i) = *((char *)data.bytes + data.length - i - 1);
    }
    return tmpData.copy;
}

+ (NSData *)SHA256WithData:(NSData *)data {
    unsigned char result[SHA256_DIGEST_LENGTH];
    memset(result, 0, SHA256_DIGEST_LENGTH);    
    sha256_Raw(data.bytes, data.length, result);
    NSData *bin = [NSData dataWithBytes:result length:SHA256_DIGEST_LENGTH];
    return bin;
}

+ (NSData *)SHA3_256WitData:(NSData *)data {
    unsigned char result[SHA256_DIGEST_LENGTH];
    memset(result, 0, SHA256_DIGEST_LENGTH);
    
    SHA3_CTX context;
    keccak_256_Init(&context);
    keccak_Update(&context, data.bytes, (size_t)data.length);
    keccak_Final(&context, result);
    
    NSData *bin = [NSData dataWithBytes:result length:SHA256_DIGEST_LENGTH];
    return bin;
}

+ (NSString *)SHA3_256StrWithData:(NSData *)data {
    NSData *sha3Data = [self SHA3_256WitData:data];
    unsigned char *bytes = (unsigned char *)sha3Data.bytes;
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", bytes[i]];
    }
    return hash;
}

+ (int)generateSecRandom:(uint8_t *)prvkey pubkey:(uint8_t *)pubkey compress:(int)compress {
    if (prvkey == NULL|| pubkey == NULL) {
        return -1;
    }
    const int len = 32;
    uint8_t *random = (uint8_t *)malloc(len);
    memset(random, 0, len);
    arc4random_buf(random, len);
    memcpy(prvkey, random, 32);
    
    if (compress) {
        ecdsa_get_public_key33(&secp256k1, prvkey, pubkey);
    } else {
        ecdsa_get_public_key65(&secp256k1, prvkey, pubkey);
    }
    memset(random, 0, len);
    free(random);
    return 0;
}

+ (NSString *)base58Encode:(NSData *)data {
    char result[128] = {0};
    int ret = base58_encode_check((const uint8_t *)data.bytes, data.length, HASHER_SHA2, result, sizeof(result));
    DMLog(@"base58 ret:%d str:%s", ret, result);
    NSString *str = [NSString stringWithUTF8String:result];
    return str;
}

static void extracted(curve_point *R, const ecdsa_curve *curve, const bignum256 *k) {
    point_multiply(curve, k, R, R);
}

+ (NSData *)computeEncryKey:(NSData *)pivkey pubkey:(NSData *)pubkey {
    if (pubkey.length != 65 && pubkey.length != 33) {
        DMLog(@"pubkey len:%@", @(pubkey.length));
        return nil;
    }
    const ecdsa_curve *curve = &secp256k1;
    if (pubkey.length == 33) {
        uint8_t output[65] = {0};
        ecdsa_uncompress_pubkey(curve, (const uint8_t *)pubkey.bytes, output);
        pubkey = [NSData dataWithBytes:output length:65];
    }
    curve_point R;
    bn_read_be(pubkey.bytes + 1, &R.x);
    bn_read_be(pubkey.bytes + 33, &R.y);
    if (!ecdsa_validate_pubkey(curve, &R)) {
        DMLog(@"invalid pubkey:%@", pubkey.hexString);
        return nil;
    }
    
    bignum256 k;
    bn_read_be(pivkey.bytes, &k);
    point_multiply(curve, &k, &R, &R);
    
    uint8_t x[32];
    bn_write_be(&R.x, x);
    NSData *xData = [NSData dataWithBytes:x length:32];
    
    return xData;
}

+ (BOOL)checkBase58Addr:(NSString *)addr {
    if (!addr || !addr.length) {
        return NO;
    }
    uint8_t data[128] = {0};
    int ret = base58_decode_check(addr.UTF8String, HASHER_SHA2, data, 128);
    if (ret <= 0) {
        return NO;
    }
    return YES;
}



@end
