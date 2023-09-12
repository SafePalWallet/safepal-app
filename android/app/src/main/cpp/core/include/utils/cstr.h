#ifndef __UTIL_CSTR_H__
#define __UTIL_CSTR_H__

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    char *str;    /* string data, incl. NUL */
    size_t len;   /* length of string, not including NUL */
    size_t _alloc; /* total allocated buffer length */
} cstring;

cstring *cstr_new_sz(size_t sz);

cstring *cstr_new(const char *init_str);

cstring *cstr_new_buf(const void *buf, size_t sz);

cstring *cstr_new_cstr(const cstring *copy_str);

int cstr_init(cstring *s, size_t sz);

void cstr_free(cstring *s);

int cstr_equal(const cstring *a, const cstring *b);

int cstr_compare(const cstring *a, const cstring *b);

int cstr_reserve(cstring *s, size_t sz);

int cstr_resize(cstring *s, size_t sz);

int cstr_clean(cstring *s);

int cstr_erase(cstring *s, size_t pos, long len);

int cstr_set_buf(cstring *s, const void *buf, size_t sz);

int cstr_append_buf(cstring *s, const void *buf, size_t sz);

int cstr_append_str(cstring *s, const char *str);

int cstr_append_cstr(cstring *s, cstring *append);

int cstr_append_c(cstring *s, char ch);

#ifdef __cplusplus
}
#endif

#endif
