
#ifndef ANDROID_CRYPTO_UTILS_H
#define ANDROID_CRYPTO_UTILS_H

#include <bip32.h>

#ifdef __cplusplus
extern "C" {
#endif

extern int hasherTypeFromName(const char *name);

extern int getChildHdnode(HDNode *inout, const char *curve, int childIndex, int singlekey);

extern int bench32DecodeAddr(const uint8_t *address, size_t size, uint8_t *out, size_t *outLen, const char *expectHrp);

extern int ethAddrForNode(HDNode *node, char *addr, int size);

extern int getHDNodeXpub(HDNode *node, const char *curve, const uint32_t magic, const uint32_t fingerprint, char *result, int size);

extern int checkEthAddr(const char *address, int size);

extern int base58Decode(
                        const char *address,
                        uint8_t *output,
                        size_t *outputLen,
                        const char *hasherName
                        );

extern int segwitAddrEncode(
        char *address,
        int size,
        HDNode *hdnode,
        const char *curve,
        const uint32_t index,
        const int changeIndex,
        const char *hrp,
        const int version,
        const int singleKey
        );

// get base58 address
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
        const int singleKey);

#ifdef __cplusplus
}
#endif

#endif //ANDROID_CRYPTO_UTILS_H

