#include "cstr.h"

#include <stdlib.h>
#include <string.h>

#define CSTRING_FLAG_DYNAMIC 0x80000000
#define CSTRING_FLAG_MASK 0xC0000000
#define CSTRING_ALLOC_MASK 0x3FFFFFFF

#define CSTR_IS_DYNAMIC(s) ((s)->_alloc & CSTRING_FLAG_DYNAMIC)
#define CSTR_SET_DYNAMIC(s) ((s)->_alloc |= CSTRING_FLAG_DYNAMIC)

#define CSTR_BUFFER_SIZE 16

#if CSTR_BUFFER_SIZE
static int G_lock = 0;

static cstring G_CSTR_BUFF[CSTR_BUFFER_SIZE];

static inline void
LOCK() {
    while (__sync_lock_test_and_set(&(G_lock), 1)) {}
}

static inline void
UNLOCK() {
    __sync_lock_release(&(G_lock));
}

#endif

static int cstr_alloc_min_sz(cstring *s, size_t sz) {
    char *new_s;
    sz = (sz + 1 + 3) & ~(3); // NULL overhead & ALIGN 4
    if (sz > CSTRING_ALLOC_MASK) {
        return 0;
    }
    size_t alloc = s->_alloc & CSTRING_ALLOC_MASK;
    if (alloc && (alloc >= sz))
        return 1;
    new_s = realloc(s->str, sz);
    if (!new_s)
        return 0;
    s->str = new_s;
    s->_alloc = (s->_alloc & CSTRING_FLAG_MASK) | sz;
    s->str[s->len] = 0;
    return 1;
}

cstring *cstr_new_sz(size_t sz) {
    int i;
    cstring *s = NULL;
#if CSTR_BUFFER_SIZE
    LOCK();
    for (i = 0; i < CSTR_BUFFER_SIZE; i++) {
        if (!G_CSTR_BUFF[i]._alloc) {
            s = &G_CSTR_BUFF[i];
            s->len = 0;
            s->str = 0;
            break;
        }
    }
    UNLOCK();
#endif
    if (!s) {
        s = calloc(1, sizeof(cstring));
        if (!s)
            return NULL;
        CSTR_SET_DYNAMIC(s);
    }

    if (!cstr_alloc_min_sz(s, sz)) {
        if (CSTR_IS_DYNAMIC(s)) free(s);
        return NULL;
    }
    return s;
}

cstring *cstr_new_buf(const void *buf, size_t sz) {
    cstring *s = cstr_new_sz(sz);
    if (!s)
        return NULL;

    memcpy(s->str, buf, sz);
    s->len = sz;
    s->str[s->len] = 0;

    return s;
}

cstring *cstr_new_cstr(const cstring *copy_str) {
    return cstr_new_buf(copy_str->str, copy_str->len);
}

cstring *cstr_new(const char *init_str) {
    size_t slen;

    if (!init_str || !*init_str)
        return cstr_new_sz(0);

    slen = strlen(init_str);
    return cstr_new_buf(init_str, slen);
}

int cstr_init(cstring *s, size_t sz) {
    if (!s) return 0;
    memset(s, 0, sizeof(*s));
    return cstr_alloc_min_sz(s, sz);
}

void cstr_free(cstring *s) {
    if (!s) return;
    LOCK();
    size_t is_d = CSTR_IS_DYNAMIC(s);
    if (s->str) free(s->str);
    memset(s, 0, sizeof(*s));
    if (is_d) free(s);
    UNLOCK();
}

int cstr_reserve(cstring *s, size_t sz) {
    return cstr_alloc_min_sz(s, sz + s->len);
}

int cstr_resize(cstring *s, size_t new_sz) {
    /* no change */
    if (new_sz == s->len)
        return 1;

    /* truncate string */
    if (new_sz <= s->len) {
        s->len = new_sz;
        s->str[s->len] = 0;
        return 1;
    }

    /* increase string size */
    if (!cstr_alloc_min_sz(s, new_sz))
        return 0;

    /* contents of string tail undefined */

    s->len = new_sz;
    s->str[s->len] = 0;

    return 1;
}

int cstr_clean(cstring *s) {
    return cstr_resize(s, 0);
}

int cstr_set_buf(cstring *s, const void *buf, size_t sz) {
    if (!cstr_resize(s, sz))
        return 0;

    memcpy(s->str, buf, sz);
    s->len = sz;
    s->str[s->len] = 0;

    return 1;
}

int cstr_append_buf(cstring *s, const void *buf, size_t sz) {
    if (!cstr_alloc_min_sz(s, s->len + sz))
        return 0;

    memcpy(s->str + s->len, buf, sz);
    s->len += sz;
    s->str[s->len] = 0;

    return 1;
}

int cstr_append_str(cstring *s, const char *str) {
    return cstr_append_buf(s, str, strlen(str));
}

int cstr_append_cstr(cstring *s, cstring *append) {
    return cstr_append_buf(s, append->str, append->len);
}

int cstr_append_c(cstring *s, char ch) {
    return cstr_append_buf(s, &ch, 1);
}

int cstr_equal(const cstring *a, const cstring *b) {
    if (a == b)
        return 1;
    if (!a || !b)
        return 0;
    if (a->len != b->len)
        return 0;
    return (memcmp(a->str, b->str, a->len) == 0);
}

int cstr_compare(const cstring *a, const cstring *b) {
    unsigned int i;
    if (a->len > b->len)
        return (1);
    if (a->len < b->len)
        return (-1);

    /* length equal, byte per byte compare */
    for (i = 0; i < a->len; i++) {
        char a1 = a->str[i];
        char b1 = b->str[i];

        if (a1 > b1)
            return (1);
        if (a1 < b1)
            return (-1);
    }
    return (0);
}

int cstr_erase(cstring *s, size_t pos, long len) {
    long old_tail;

    if (pos == s->len && len == 0)
        return 1;
    if (pos >= s->len)
        return 0;

    old_tail = s->len - pos;
    if ((len >= 0) && (len > old_tail))
        return 0;

    memmove(&s->str[pos], &s->str[pos + len], old_tail - len);
    s->len -= len;
    s->str[s->len] = 0;

    return 1;
}
