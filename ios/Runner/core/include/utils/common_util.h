#ifndef WALLET_COMMON_UTIL_H
#define WALLET_COMMON_UTIL_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

int base34encode(uint32_t number, char *buffer, int maxlen);

int base62encode(int number, char *buffer, int maxlen);

int base62decode(const char *buffer);

char *bin_to_hex(const unsigned char *bin_in, size_t inlen, char *hex_out);

char *bin_to_hex_b(const unsigned char *bin_in, size_t inlen, char *hex_out);

int hex_to_bin(const char *str, int inLen, unsigned char *out, unsigned int outlen);

int uint32_safe_add(uint32_t a, uint32_t b, uint32_t *rs);

int uint64_safe_add(uint64_t a, uint64_t b, uint64_t *rs);

int uint64_safe_multiply(uint64_t a, uint64_t b, uint64_t *rs);

int buffer_is_zero(const uint8_t *buff, int len);

int buffer_is_ff(const uint8_t *buff, int len);

char *pretty_float_string(char *str, int dec_n);

int is_printable_str(const char *s);

const char *omit_string(char *dst, const char *src, int start_len, int end_len);

#ifdef __cplusplus
}
#endif
#endif
