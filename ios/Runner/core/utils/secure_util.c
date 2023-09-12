#include <string.h>
#include "secure_util.h"
#include "aes/aes.h"
#include "sha2.h"
#include "memzero.h"

static int geniv(unsigned char *iv, const unsigned char *key, int keylen) {
    uint8_t digest[32];
    sha256_Raw(key, keylen, digest);
    memcpy(iv, digest, AES_BLOCK_SIZE);
    memzero(digest, 32);
    return AES_BLOCK_SIZE;
}

int aes256_encrypt(const unsigned char *ibuf, unsigned char *obuf, size_t size, const unsigned char *key) {
    aes_encrypt_ctx ctx;
    unsigned char iv[AES_BLOCK_SIZE];
    if (ibuf == NULL || size <= 0 || key == NULL) {
        return -1;
    }
    if (aes_encrypt_key256(key, &ctx) != EXIT_SUCCESS) {
        return -1;
    }
    geniv(iv, key, 32);
    int ret = aes_cfb_encrypt(ibuf, obuf, size, iv, &ctx);
    memzero(iv, sizeof(iv));
    return ret;
}

int aes256_decrypt(const unsigned char *input, unsigned char *output, size_t size, const unsigned char *key) {
    aes_encrypt_ctx ctx;
    unsigned char iv[AES_BLOCK_SIZE];
    if (input == NULL || size <= 0 || output == NULL || key == NULL) {
        return -1;
    }
    if (aes_encrypt_key256(key, &ctx) != EXIT_SUCCESS) {
        return -1;
    }
    geniv(iv, key, 32);
    int ret = aes_cfb_decrypt(input, output, size, iv, &ctx);
    memzero(iv, sizeof(iv));
    return ret;
}
