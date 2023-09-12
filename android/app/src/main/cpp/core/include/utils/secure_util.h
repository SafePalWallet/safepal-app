
#ifndef WALLET_SECURE_UTIL_H
#define WALLET_SECURE_UTIL_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

int aes256_encrypt(const unsigned char *input, unsigned char *output, size_t size, const unsigned char *key);

int aes256_decrypt(const unsigned char *input, unsigned char *output, size_t size, const unsigned char *key);

#ifdef __cplusplus
}
#endif

#endif
