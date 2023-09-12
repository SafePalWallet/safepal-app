#ifndef WALLET_BASE64_H
#define WALLET_BASE64_H

#ifdef __cplusplus
extern "C" {
#endif

int Base64encode_len(int len);

int Base64encode(char *coded_dst, const unsigned char *plain_src, int len_plain_src, int foldchar);

int Base64RefactorStr(char *coded_dst, int len);

char Base64Char(int index);

int Base64decode_len(const char *coded_src, int limit_len);

int Base64decode(unsigned char *plain_dst, const char *coded_src, int limit_len);

int UrlSafe(char *buf, int len);

#ifdef __cplusplus
}
#endif

#endif
