#define LOG_TAG "util"

#include <limits.h>
#include <string.h>

#include "common_util.h"

static const char *base62chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
static const char *base34chars = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ";

int base34encode(uint32_t number, char *buffer, int maxlen) {
    if (maxlen < 1) {
        return -1;
    }
    int pos;
    int i;
    for (pos = maxlen - 1; pos >= 0; pos--) {
        i = number % 34;
        buffer[pos] = base34chars[i];
        number = (number - i) / 34;
    }
    buffer[maxlen] = 0;
    return 0;
}

int base62encode(int number, char *buffer, int maxlen) {
    if (number < 0 || maxlen < 1) {
        return -1;
    }
    int pos;
    int i;
    for (pos = maxlen - 1; pos >= 0; pos--) {
        i = number % 62;
        buffer[pos] = base62chars[i];
        number = (number - i) / 62;
    }
    buffer[maxlen] = 0;
    return 0;
}

int base62decode(const char *buffer) {
    int number = 0;
    int i;
    char c;
    int val;
    for (i = 0; i < 6; i++) {
        c = buffer[i];
        if (c >= '0' && c <= '9') {
            val = c - '0';
        } else if (c >= 'A' && c <= 'Z') {
            val = c - 'A' + 10;
        } else if (c >= 'a' && c <= 'z') {
            val = c - 'a' + 36;
        } else {
            break;
        }
        number = number * 62 + val;
    }
    return number;
}

char *bin_to_hex(const unsigned char *bin_in, size_t inlen, char *hex_out) {
    static const char digits[] = "0123456789abcdef";
    size_t i = 0;
    for (; i < inlen; i++) {
        hex_out[i * 2] = digits[(bin_in[i] >> 4) & 0xF];
        hex_out[i * 2 + 1] = digits[bin_in[i] & 0xF];
    }
    hex_out[i * 2] = '\0';
    return hex_out;
}

char *bin_to_hex_b(const unsigned char *bin_in, size_t inlen, char *hex_out) {
    static const char digits[] = "0123456789ABCDEF";
    size_t i = 0;
    for (; i < inlen; i++) {
        hex_out[i * 2] = digits[(bin_in[i] >> 4) & 0xF];
        hex_out[i * 2 + 1] = digits[bin_in[i] & 0xF];
    }
    hex_out[i * 2] = '\0';
    return hex_out;
}

int hex_to_bin(const char *str, int inLen, unsigned char *out, unsigned int outlen) {
    unsigned int bLen = inLen / 2;
    unsigned int i;
    unsigned int n;
    if (bLen > outlen) bLen = outlen;
    memset(out, 0, bLen);
    for (i = 0; i < bLen; i++) {
        n = i * 2;
        if (str[n] >= '0' && str[n] <= '9') {
            *out = (str[n] - '0') << 4;
        } else if (str[n] >= 'a' && str[n] <= 'f') {
            *out = (10 + str[n] - 'a') << 4;
        } else if (str[n] >= 'A' && str[n] <= 'F') {
            *out = (10 + str[n] - 'A') << 4;
        } else {
            break;
        }
        n++;
        if (str[n] >= '0' && str[n] <= '9') {
            *out |= (str[n] - '0');
        } else if (str[n] >= 'a' && str[n] <= 'f') {
            *out |= (10 + str[n] - 'a');
        } else if (str[n] >= 'A' && str[n] <= 'F') {
            *out |= (10 + str[n] - 'A');
        } else {
            break;
        }
        out++;
    }
    return i;
}

int uint32_safe_add(uint32_t a, uint32_t b, uint32_t *rs) {
    if (UINT_MAX - a < b) {
        return 0;
    } else {
        *rs = a + b;
        return 1;
    }
}

int uint64_safe_add(uint64_t a, uint64_t b, uint64_t *rs) {
    if (ULLONG_MAX - a < b) {
        return 0;
    } else {
        *rs = a + b;
        return 1;
    }
}

int uint64_safe_multiply(uint64_t a, uint64_t b, uint64_t *rs) {
    if (LLONG_MAX / a < b) {
        return 0;
    } else {
        *rs = a * b;
        return 1;
    }
}

int buffer_is_zero(const unsigned char *buff, int len) {
    int i;
    uint32_t result = 0;
    for (i = 0; i < len; i++) {
        result |= buff[i];
    }
    return !result;
}

int buffer_is_ff(const unsigned char *buff, int len) {
    int i;
    for (i = 0; i < len; i++) {
        if (buff[i] != 0xFF) {
            return 0;
        }
    }
    return 1;
}

char *pretty_float_string(char *str, int dec_n) {
    if (dec_n < 0) dec_n = 0;
    char *dot = strchr(str, '.');
    if (!dot) {
        return str;
    }
    dot += dec_n;
    char *p = dot + strlen(dot) - 1;
    while (p > dot && *p == '0') {
        *p-- = 0;
    }
    if (dec_n == 0 && p == dot) {
        *dot = 0;
    }
    return str;
}

int is_printable_str(const char *s) {
    while (*s) {
        if ((*s >= 0x20 && *s <= 0x7e) || *s == 0x0d || *s == 0x0a) {
            s++;
        } else {
            return 0;
        }
    }
    return 1;
}

const char *omit_string(char *dst, const char *src, int start_len, int end_len) {
    char *d;
    const char *s;
    int src_len = strlen(src);
    if (src_len <= start_len + 3 + end_len) { //do nothing
        if (dst == src) {
            return src;
        } else {
            return strcpy(dst, src);
        }
    }
    s = src + src_len - end_len;
    d = dst + start_len;
    if (dst != src) {
        strncpy(dst, src, start_len);
    }
    *d++ = '.';
    *d++ = '.';
    *d++ = '.';
    while (*s) {
        *d++ = *s++;
    }
    *d = 0;
    return dst;
}