//

#ifndef SFP_CRYPTO_PLUGIN_HEADER

#define SFP_CRYPTO_PLUGIN_HEADER

#include <stdio.h>
#include <stdlib.h>

#include "SFPMacro.h"
#include "secp256k1.h"
#include "base58.h"
#include "sha2.h"
#include "segwit_addr.h"
#include "qr_pack.h"
#include "secure_util.h"
#include "bip39.h"
#include "base32.h"
#include <memzero.h>
#include <common_util.h>
#include <debug.h>

#include "address.h"

#import "SFPCryptoPlugin.h"
#import <NSData+YYAdd.h>
#import <Flutter/Flutter.h>
#import "SFPCryptoUtil.h"
#import "SFPPubHDNode.h"
#import <YYCategories/YYCategories.h>
#import "SFPEIP55.h"
#import "SecureRandomUtil.h"

#import "SFPFlutterChannelResp.h"
#include "crypto_utils.h"


typedef void(^PluginCallHandler)(FlutterMethodCall *call, FlutterResult resp);

@interface CallHandler : NSObject
+ (instancetype)callHandler:(PluginCallHandler)hander;
@property (nonatomic, copy) PluginCallHandler handler;
@end
@implementation CallHandler
+ (instancetype)callHandler:(PluginCallHandler)hander {
    CallHandler *obj = [[CallHandler alloc] init];
    obj.handler = hander;
    return obj;
}
@end

#endif


@implementation SFPCryptoPlugin

static void  getHDNodeFromOc(SFPPubHDNode *ocNode, HDNode *output) {
    if (output == NULL) {
        return;
    }
    memset(output, 0, sizeof(HDNode));
    output->depth = ocNode.depth;
    output->child_num = ocNode.childNum;
    memcpy(output->public_key, ocNode.publicKey.bytes, ocNode.publicKey.length);
    memcpy(output->chain_code, ocNode.chainCode.bytes, ocNode.chainCode.length);
}

static SFPPubHDNode *nodeFromJson(NSDictionary *nodeDic) {
    if (!nodeDic || ![nodeDic isKindOfClass:[NSDictionary class]]) {
        return NULL;
    }
    
    SFPPubHDNode *pubNode = [[SFPPubHDNode alloc] init];
    
    NSInteger depth = [nodeDic[@"depth"] integerValue];
    FlutterStandardTypedData *chainCode = nodeDic[@"chainCode"];
    FlutterStandardTypedData *pubKey = nodeDic[@"publicKey"];
    
    if ([nodeDic[@"fingerprint"] isKindOfClass:[NSNumber class]]) {
        pubNode.fingerprint = [nodeDic[@"fingerprint"] intValue];
    }
    if ([nodeDic[@"singleKey"] isKindOfClass:[NSNumber class]]) {
        pubNode.singleKey = [nodeDic[@"singleKey"] intValue];
    }
    NSInteger childNum = [nodeDic[@"childNum"] integerValue];
    pubNode.childNum = (uint32_t)childNum;
    pubNode.publicKey = pubKey.data;
    pubNode.chainCode = chainCode.data;
    pubNode.depth = (uint32_t)depth;
    return pubNode;
}

static NSDictionary * toDictionaryFromNode(HDNode *node) {
    if (node == NULL) {
        return NULL;
    }
    NSMutableDictionary *paras = [NSMutableDictionary new];
    paras[@"depth"] = [NSNumber numberWithInt:node->depth];
    paras[@"chainCode"] =
    [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:node->chain_code length:32]];
    paras[@"publicKey"] =
    [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:node->public_key length:33]];
    paras[@"childNum"] = [NSNumber numberWithInt:node->child_num];
    return paras.copy;
}

static void  __aes256CFBEncrypt(FlutterMethodCall *call, FlutterResult resp) {
    FlutterStandardTypedData *data = call.arguments[@"data"];
    FlutterStandardTypedData *key = call.arguments[@"key"];
    int ret = 0;
    unsigned char *output = malloc(data.data.length);
    if (output == NULL) {
        resp(NULL);
        return;
    }
    memzero(output, data.data.length);
    ret = aes256_encrypt(data.data.bytes, output, data.data.length, key.data.bytes);
    FlutterStandardTypedData *result = NULL;
    if (ret == 0) {
        result = [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:output length:data.data.length]];
    }
    memzero(output, data.data.length);
    free(output);
    resp(result);
}

static void  __aes256CFBDecrypt(FlutterMethodCall *call, FlutterResult resp) {
    FlutterStandardTypedData *data = call.arguments[@"data"];
    FlutterStandardTypedData *key = call.arguments[@"key"];
    int ret = 0;
    unsigned char *output = malloc(data.data.length);
    if (output == NULL) {
        resp(NULL);
        return;
    }
    memzero(output, data.data.length);
    ret = aes256_decrypt(data.data.bytes, output, data.data.length, key.data.bytes);
    FlutterStandardTypedData *result = NULL;
    if (ret == 0) {
        result = [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:output length:data.data.length]];
    }
    memzero(output, data.data.length);
    free(output);
    resp(result);
}

static void  __ecdsUncompressPubkey(FlutterMethodCall *call, FlutterResult resp) {
    FlutterStandardTypedData *typeData = call.arguments;
    if (typeData == NULL) {
        resp(NULL);
    }
    // secp256k1_info
    uint8_t buf[65] = {0};
    const curve_info *info = &secp256k1_info;
    int ret = ecdsa_uncompress_pubkey(info->params, (const uint8_t *)(typeData.data.bytes), buf);
    FlutterStandardTypedData *data = NULL;
    if (ret == 1) {
        NSData *bin = [NSData dataWithBytes:(const void *)buf length:65];
        data = [FlutterStandardTypedData typedDataWithBytes:bin];
    }
    memzero(buf, sizeof(buf));
    DMLog(@"ecdsa_uncompress_pubkey ret:%@", @(ret));
    resp(data);
}

static BOOL checkAddress(NSString *string, NSInteger type, NSInteger test) {
    const char *address = string.UTF8String;
    int result = checkEthAddr(address, (int)strlen(address));
    return result;
}

static void  __generateBech32Address(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *args = (NSDictionary *)call.arguments;
    NSDictionary *nodeDic = args[@"node"];
    SFPPubHDNode *pubNode = nodeFromJson(nodeDic);
    uint32_t index = (uint32_t)[args[@"index"] integerValue];
    uint32_t version = [args[@"version"] intValue];
    NSString *hrp = args[@"hrp"];
    uint32_t change = (uint32_t)[args[@"change"] unsignedIntegerValue];
    NSString *cureName = args[@"curve"];
    DMLog(@"index:%d version:%d hrp:%@ change:%d cure:%@", index, version, hrp, change, cureName);
    HDNode hdnode;
    getHDNodeFromOc(pubNode, &hdnode);
    char addressResult[128] = {0};
    NSString *address;
    int ret = segwitAddrEncode(addressResult, sizeof(addressResult), &hdnode, cureName.UTF8String, index, change, hrp.UTF8String, version, pubNode.singleKey);
    if (ret >= 0) {
        address = [NSString stringWithUTF8String:addressResult];
    }
    if (resp) {
        resp(address);
    }
}

static void  __getHDNodeXpub(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *args = (NSDictionary *)call.arguments;
    NSDictionary *nodeDic = args[@"node"];
    SFPPubHDNode *pubNode = nodeFromJson(nodeDic);
    uint32_t pubVersion = [args[@"version"] unsignedIntValue];
    NSString *cureName = args[@"curve"];
    
    HDNode hdnode;
    getHDNodeFromOc(pubNode, &hdnode);
    
    char result[128] = {0};
    int ret = getHDNodeXpub(&hdnode, cureName.UTF8String, pubVersion, pubNode.fingerprint, result, sizeof(result));
    NSString *xpub;
    if (!ret) {
        xpub = [NSString stringWithUTF8String:result];
    }
    resp(xpub);
}

static void  __segwitAddressDecode(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *paras = (NSDictionary *)call.arguments;
    NSString *address = paras[@"address"];
    NSString *hrp = paras[@"hrp"];
    DMLog(@"call segwitAddrDecode paras address:%@ hrp:%@", address, hrp);
    int version = 0;
    uint8_t results[128] = {0};
    size_t resultLen = 128;
    int ret = segwit_addr_decode(&version, results, &resultLen, hrp.UTF8String, address.UTF8String);
    DMLog(@"call segwitAddrDecode method ret:%d version:%d hrp:%@", ret, version, hrp);
    FlutterStandardTypedData *typeData;
    if (ret) {
        typeData = [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:results length:resultLen]];
    }
    DMLog(@"segwit address version:%d", version);
    resp(typeData);
}

static void  __base58Decode(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *paras = (NSDictionary *)call.arguments;
    NSString *addr = paras[@"address"];
    NSString *haser = paras[@"base58Hasher"];
    
    size_t len = [paras[@"len"] intValue];
    if (len <= 0) {
        len = 128;
    }
    uint8_t *result = (uint8_t *)malloc(len);
    int ret = base58Decode(addr.UTF8String, result, &len, haser.UTF8String);
    FlutterStandardTypedData *typeData;
    if (ret) {
        typeData = [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:result length:len]];
    }
    free(result);
    resp(typeData);
}

static void  __bech32Decode(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *paras = (NSDictionary *)call.arguments;
    NSString *addr = paras[@"address"];
    NSString *hrp = paras[@"hrp"];
    uint8_t results[128] = {0};
    size_t resultLen = 128;
    int ret = bench32DecodeAddr((const uint8_t *)addr.UTF8String, addr.length, results, &resultLen, hrp.UTF8String);
    FlutterStandardTypedData *typeData;
    if (ret) {
        typeData = [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:results length:resultLen]];
    }
    resp(typeData);
}

static void  __bech32EncodeAddress(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *paras = (NSDictionary *)call.arguments;
    FlutterStandardTypedData *data = paras[@"data"];
    NSString *hrp = paras[@"hrp"];
    char results[128] = {0};
    int ret = bech32_addr_encode(results, hrp.UTF8String, data.data.bytes, data.data.length);
    NSString *address;
    if (ret) {
        address = [NSString stringWithUTF8String:results];
    }
    resp(address);
}

static void  __generateCryptoKey(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *paras = (NSDictionary *)call.arguments;
    FlutterStandardTypedData *prvData = paras[@"private_key"];
    FlutterStandardTypedData *pubData = paras[@"pub_key"];
    NSData *aeskey = [SFPCryptoUtil computeEncryKey:prvData.data pubkey:pubData.data];
    resp(aeskey ? [FlutterStandardTypedData typedDataWithBytes:aeskey] : NULL);
    memzero((void *)aeskey.bytes, aeskey.length);
}

static void  __base58Encode(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *paras = (NSDictionary *)call.arguments;
    FlutterStandardTypedData *data = paras[@"data"];
    NSString *base58Hasher = paras[@"base58Hasher"];
    char result[128] = {0};
    int ret = 0;
    if (base58Hasher != NULL) {
        int type = hasherTypeFromName(base58Hasher.UTF8String);
        ret = base58_encode_check((const uint8_t *)data.data.bytes, (int)(data.data.length), type, result, sizeof(result));
    } else {
        size_t outLen = sizeof(result);
        ret = b58enc(result, &outLen, (const void *)data.data.bytes, (size_t)data.data.length);
    }
    NSString *str = NULL;
    if (ret > 0) {
        str = [NSString stringWithUTF8String:result];
    }
    DMLog(@"base58 ret:%d str:%s", ret, result);
    resp(str);
}

static void __generateEcdsaKeypair(FlutterMethodCall *call, FlutterResult resp) {
    uint8_t data1[32] = {0};
    uint8_t data2[65] = {0};
    int compress = [call.arguments[@"compress"] intValue];
    int len = 65;
    if (compress == 1) {
        len = 33;
    }
    [SFPCryptoUtil generateSecRandom:data1 pubkey:data2 compress:compress];
    NSData *secRandom = [NSData dataWithBytes:data2 length:len];
    NSData *privkeyData = [NSData dataWithBytes:data1 length:32];
    resp(@[secRandom.hexString.lowercaseString, privkeyData.hexString.lowercaseString]);
    memzero((void *)secRandom.bytes, secRandom.length);
    memzero((void *)privkeyData.bytes, privkeyData.length);
    memzero(data1, sizeof(data1));
    memzero(data2, sizeof(data2));
}

static void  __sha256(FlutterMethodCall *call, FlutterResult resp) {
    FlutterStandardTypedData *typedData = call.arguments;
    NSData *result = [SFPCryptoUtil SHA256WithData:typedData.data];
    resp([FlutterStandardTypedData typedDataWithBytes:result]);
}

static void  __generateBitcoinAddress(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *args = (NSDictionary *)call.arguments;
    NSDictionary *nodeDic = args[@"node"];
    SFPPubHDNode *pubNode = nodeFromJson(nodeDic);
    NSString *cureName = args[@"curve"];
    uint32_t prefix = [args[@"prefix"] intValue];
    int changeIndex = [args[@"changeIndex"] intValue];
    int index = [args[@"index"] intValue];
    int characterSet = [args[@"characterSet"] intValue];
    int purpose = [args[@"purpose"] intValue];
    
    HDNode hdnode;
    getHDNodeFromOc(pubNode, &hdnode);
    
    char address[128] = {0};
    size_t addressLen = 128;
    int ret = getHDNodeBitcoinAddress(&hdnode, changeIndex, index, cureName.UTF8String, prefix, characterSet, purpose, address, addressLen, pubNode.singleKey);
    NSString *result;
    if (!ret) {
        result = [NSString stringWithUTF8String:address];
    }
    if (resp) {
        resp(result);
    }
}


static void __getEthAddressForNode(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *args = (NSDictionary *)call.arguments;
    NSDictionary *nodeDic = args[@"node"];
    SFPPubHDNode *pubNode = nodeFromJson(nodeDic);
    HDNode hdnode;
    getHDNodeFromOc(pubNode, &hdnode);
    char results[128] = {0};
    int ret = ethAddrForNode(&hdnode, results, 128);
    NSString *address;
    if (ret == 0) {
        address = [NSString stringWithUTF8String:results];
    }
    if (resp) {
        resp(address);
    }
}

static void  __checkEthAddress(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *args = (NSDictionary *)call.arguments;
    NSString *address = args[@"address"];
    int ret = checkEthAddr(address.UTF8String, (int)(address.length));
    if (resp) {
        resp([NSNumber numberWithBool:ret != 0]);
    }
}

static void  __getChildHDNode(FlutterMethodCall *call, FlutterResult resp) {
    NSDictionary *args = (NSDictionary *)call.arguments;
    NSDictionary *nodeDic = args[@"node"];
    SFPPubHDNode *pubNode = nodeFromJson(nodeDic);
    NSString *curve = args[@"curve"];
    NSNumber *number = args[@"childIndex"];
    if (curve == NULL || number == NULL || pubNode == NULL) {
        resp(NULL);
        return;
    }
    HDNode hdnode;
    memzero(&hdnode, sizeof(HDNode));
    getHDNodeFromOc(pubNode, &hdnode);
    int index = [number intValue];
    int ret = getChildHdnode(&hdnode, [curve UTF8String], index, pubNode.singleKey);
    if (ret < 0) {
        resp(NULL);
    } else {
        resp(toDictionaryFromNode(&hdnode));
    }
}

+ (void)registerWithMethodCall:(FlutterMethodCall *)call resp:(FlutterResult)resp {
    if ([call.method isEqualToString:@"generateEcdsaKeypair"]) {
        __generateEcdsaKeypair(call, resp);
    } else if ([call.method isEqualToString:@"base58Encode"]) {
        __base58Encode(call, resp);
    } else if ([call.method isEqualToString:@"base58Decode"]) {
        __base58Decode(call, resp);
    } else if ([call.method isEqualToString:@"generateCryptoKey"]) {
        __generateCryptoKey(call, resp);
    } else if ([call.method isEqualToString:@"checkEthAddress"]) {
        __checkEthAddress(call, resp);
    } else if ([call.method isEqualToString:@"getChildHDNode"]) {
        __getChildHDNode(call, resp);
    } else if ([call.method isEqualToString:@"getEthAddressForNode"]) {
        __getEthAddressForNode(call, resp);
    } else if ([call.method isEqualToString:@"getHDNodeXpub"]) {
        __getHDNodeXpub(call, resp);
    } else if ([call.method isEqualToString:@"sha256"]) {
        __sha256(call, resp);
    } else if ([call.method isEqualToString:@"generateBitcoinAddress"]) {
        __generateBitcoinAddress(call, resp);
    } else if ([call.method isEqualToString:@"aes256CFBEncrypt"]) {
        __aes256CFBEncrypt(call, resp);
    } else if ([call.method isEqualToString:@"aes256CFBDecrypt"]) {
        __aes256CFBDecrypt(call, resp);
    } else if ([call.method isEqualToString:@"generateBech32Address"]) {
        __generateBech32Address(call, resp);
    } else {
        [self respError:ANBFlutterErrorCodeNotImplement resp:resp];
    }
}

@end
