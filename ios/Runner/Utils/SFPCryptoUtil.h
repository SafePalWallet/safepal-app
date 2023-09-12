//

#import <Foundation/Foundation.h>
#include "bignum.h"
#include "secp256k1.h"
#include "ecdsa.h"
#include "sha3.h"
#include "sha2.h"
#include "aes.h"
#include "curves.h"
#include "ecdsa.h"

@class SFPPubHDNode;

@interface SFPCryptoUtil : NSObject

+ (NSData *)SHA256WithData:(NSData *)data;
+ (NSData *)SHA3_256WitData:(NSData *)data;
+ (NSString *)SHA3_256StrWithData:(NSData *)data;

+ (NSString *)base58Encode:(NSData *)data;
+ (int)generateSecRandom:(uint8_t *)prvkey pubkey:(uint8_t *)pubkey compress:(int)compress;
+ (NSData *)computeEncryKey:(NSData *)pivkey pubkey:(NSData *)pubkey;

+ (NSData *)revertData:(NSData *)data;

+ (BOOL)checkBase58Addr:(NSString *)addr;

@end
