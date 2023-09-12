
#define LOG_TAG "crypto_utils.c"

#include "crypto_utils.h"

#include <string.h>
#include <bip39.h>
#include <base58.h>
#include <segwit_addr.h>
#include <string.h>
#include <curves.h>
#include <rand.h>
#include <ripemd160.h>
#include <secp256k1.h>
#include <address.h>
#include <common_util.h>

int hasherTypeFromName(const char *name) {
    if (name == NULL) {
        return -1;
    }
    if (!strcmp(name, "sha256ripemd")) {
        return HASHER_SHA2_RIPEMD;
    } else if (!strcmp(name, "blake256ripemd")) {
        return HASHER_BLAKE_RIPEMD;
    } else if (!strcmp(name, "sha256d")) {
        return HASHER_SHA2D;
    } else if (!strcmp(name, "blake256d")){
        return HASHER_BLAKED;
    } else if (!strcmp(name, "blake256")) {
        return HASHER_BLAKE;
    } else if (!strcmp(name, "blake256ripemd")) {
        return HASHER_BLAKE_RIPEMD;
    } else if (!strcmp(name, "groestl512d")) {
        return HASHER_GROESTLD_TRUNC;
    } else if (!strcmp(name, "sha256")) {
        return HASHER_SHA2;
    } else if (!strcmp(name, "sha3k")) {
        return HASHER_SHA3K;
    } else if (!strcmp(name, "ripemd160")) {
        return  HASHER_RIPEMD160;
    } else if (!strcmp(name, "sha3")) {
        return  HASHER_SHA3;
    }
    return -1;
}

int getChildHdnode(HDNode *inout, const char *curve, int childIndex, int singlekey) {
    const curve_info *curveInfo = get_curve_by_name(curve);
    if (curveInfo == NULL) {
        return -1;
    }
    inout->curve = curveInfo;
    if (singlekey == 1) {
        return 0;
    }
    HDNode hdnode;
    memcpy(&hdnode, inout, sizeof(HDNode));
    int ret = hdnode_public_ckd(&hdnode, childIndex);
    if (ret != 1) {
        return -2;
    }
    memcpy(inout, &hdnode, sizeof(HDNode));
    return 0;
}


static int getHdnode(HDNode *inout, const char *curve, int changeIndex, int index, int singlekey) {
    const curve_info *curveInfo = get_curve_by_name(curve);
    if (curveInfo == NULL) {
        return -1;
    }
    inout->curve = curveInfo;
    if (singlekey == 1) {
        return 0;
    }
    HDNode hdnode;
    memcpy(&hdnode, inout, sizeof(HDNode));

    int ret = hdnode_public_ckd(&hdnode, changeIndex);
    if (ret != 1) {
        return -2;
    }
    ret = hdnode_public_ckd(&hdnode, index);
    if (ret != 1) {
        return -3;
    }
    memcpy(inout, &hdnode, sizeof(HDNode));
    return 0;
}

static uint16_t crc16(uint8_t *bytes, int length) {
    // Calculate checksum for existing bytes
    uint16_t crc = 0x0000;
    uint16_t polynomial = 0x1021;

    for (int i = 0; i < length; i++) {
        uint8_t byte = bytes[i];
        for (int bitidx = 0; bitidx < 8; bitidx++) {
            uint8_t bit = ((byte >> (7 - bitidx) & 1) == 1);
            uint8_t c15 = ((crc >> 15 & 1) == 1);
            crc <<= 1;
            if (c15 ^ bit) {
                crc ^= polynomial;
            }
        }
    }
    return crc & 0xffff;
}

int segwitAddrEncode(
        char *address,
        int size,
        HDNode *hdnode,
        const char *curve,
        const uint32_t index,
        const int changeIndex,
        const char *hrp,
        const int version,
        const int singleKey) {
    HDNode hd2;
    memcpy(&hd2, hdnode, sizeof(HDNode));
    int  ret = getHdnode(&hd2, curve, changeIndex, index, singleKey);
    if (ret != 0) {
        return -1;
    }
    uint8_t pubkeyHash[20] = {0};
    ecdsa_get_pubkeyhash(hd2.public_key, HASHER_SHA2_RIPEMD, pubkeyHash);
    if (!segwit_addr_encode(address, hrp, version, pubkeyHash, sizeof(pubkeyHash))) {
        return -1;
    }
    return 0;
}

static int ethAddressCheckSum(const char *hash, int size,  int index, char *addr, int outSize) {
    if (hash == 0 || size != 20 || outSize <= 42) {
        return -1;
    }

    uint32_t slip44 = index & 0x7fffffff;
    bool rskip60 = false;
    uint32_t chain_id = 0;
    switch (slip44) {
        case 137:
            rskip60 = true;
            chain_id = 30;
            break;
        case 37310:
            rskip60 = true;
            chain_id = 31;
            break;
    }
    addr[0] = '0';
    addr[1] = 'x';
    ethereum_address_checksum((const uint8_t *)hash, (addr + 2), rskip60, chain_id);
    return 0;
}

int ethAddrForNode(HDNode *node, char *addr, int size) {
    if (node == NULL || addr == NULL || size <= 0) {
        return -1;
    }
    uint8_t pubkeyhash[20] = {0};
    const curve_info *curveInfo = get_curve_by_name(SECP256K1_NAME);
    if (curveInfo == NULL) {
        return -1;
    }
    node->curve = curveInfo;
    if (!hdnode_get_ethereum_pubkeyhash(node, pubkeyhash)) {
        return -1;
    }
    bool rskip60 = false;
    uint32_t chain_id = 0;
    addr[0] = '0';
    addr[1] = 'x';
    ethereum_address_checksum(pubkeyhash, addr + 2, rskip60, chain_id);
    return 0;
}

int bench32DecodeAddr(const uint8_t *address, size_t size, uint8_t *out, size_t *outLen, const char *expectHrp) {
    if (address == NULL || expectHrp == NULL) {
        return 0;
    }
    uint8_t bytes[32] = {0};
    size_t byteLen = 0;
    char hrp[32] = {0};
    int ret = bech32_decode(hrp, bytes, (&byteLen), (const char *)address);
    if (!ret || (strcmp(expectHrp, hrp) != 0)) {
        return 0;
    }
    *outLen = 0;
    ret = convert_bits(out, outLen, 8, (uint8_t *)bytes, byteLen, 5, 0);
    return (*outLen == 20) && ret;
}

int getHDNodeXpub(HDNode *node, const char *curve, const uint32_t magic, const uint32_t fingerprint, char *result, int size) {
    if (node == NULL || result == NULL || size <= 0 || curve == NULL) {
        return -1;
    }
    node->curve = get_curve_by_name(curve);
    int ret = hdnode_serialize_public((const HDNode *)node, (uint32_t)fingerprint, (uint32_t)magic, result, size);
    if (ret < 0) {
        return -1;
    }
    return 0;
}

int checkEthAddr(const char *address, int size) {
    if (address == NULL) {
        return 0;
    }
    if (size != 42) {
        return 0;
    }
    if (address[0] != '0') {
        return 0;
    }
    if (address[1] != 'x' && address[1] != 'X') {
        return 0;
    }

    char data[20] = {0};
    int ret = hex_to_bin(address + 2, size - 2, data, sizeof(data));
    if (ret != 20) {
        return 0;
    }

    char addr2[43] = {0};
    ret = ethAddressCheckSum(data, sizeof(data), 0, addr2, sizeof(addr2));
    if (ret != 0) {
        return -1;
    }
    if (strncasecmp(address, addr2, size) == 0) {
        return 1;
    }
    return 0;
}

int base58Decode(const char *address, uint8_t *output, size_t *outputSize, const char *hasherName) {
    if (address == NULL) {
        return 0;
    }
    if (hasherName == NULL) {
        bool result = b58tobin(output, outputSize, address);
        if (!result) {
            *outputSize = 0;
        }
        return result;
    }
    int ret = 0;
    int hasherType = hasherTypeFromName(hasherName);
    ret = base58_decode_check(address, hasherType, output, (int)(*outputSize));
    if (ret > 0) {
        *outputSize = ret;
        return 1;
    }
    return 0;
}

int getHDNodeBitcoinAddress(
        const HDNode *node,
        const int changeIndex,
        const int index,
        const char *curveName,
        const uint32_t prefix,
        const int characterSet,
        const int purpose,
        char *addr,
        size_t addrSize,
        const int singleKey) {
    if (node == NULL || changeIndex < 0 || index < 0 || prefix < 0) {
        return -1;
    }
    if (curveName == NULL) {
        return -2;
    }

    HDNode _hdnode;
    HDNode *hdnode = &_hdnode;
    memset(hdnode, 0, sizeof(HDNode));
    memcpy(hdnode, node, sizeof(HDNode));
    int ret = getHdnode(hdnode, curveName, changeIndex, index, singleKey);
    if (ret != 0) {
        return -3;
    }
    if (purpose == 44) {
        hdnode_get_address(hdnode, prefix, addr, (int)addrSize);
    } else if (purpose == 49) {
        uint8_t pubkeyhash[21] = {0};
        hasher_Raw(HASHER_SHA2_RIPEMD, hdnode->public_key, 33, pubkeyhash);
        uint8_t script[22] = {0};
        script[0] = 0x00;
        script[1] = 0x14;
        memcpy(script + 2, pubkeyhash, 20);
        hasher_Raw(HASHER_SHA2_RIPEMD, script, sizeof(script),  pubkeyhash + 1);
        pubkeyhash[0] = prefix;
        base58_encode_check(pubkeyhash, sizeof(pubkeyhash), HASHER_SHA2D, addr, (int)addrSize);
    }
    return 0;
}
