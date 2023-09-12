#ifndef WALLET_COMMON_CORE_H
#define WALLET_COMMON_CORE_H

#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#if defined(__linux__) && !defined(__ANDROID__) && !defined(__MIPSEL__)
#include <bsd/string.h>
#include <bsd/stdlib.h>
#endif

#include "defines.h"
#include "debug.h"
#include "memzero.h"

#if defined(__MIPSEL__)
size_t strlcpy(char *dst, const char *src, size_t siz);
#endif

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

#ifndef ALIGN_SIZE
#define ALIGN_SIZE(size, align) (((size) + ((align) - 1)) & ~((align) - 1))
#endif

#define STRUCT_OFFSET(struct_type, member) ((size_t) &((struct_type *) 0)->member)

#define is_empty_string(s) (!(s) || ((s)[0]==0))
#define is_not_empty_string(s) ((s) && ((s)[0]!=0))

#endif
