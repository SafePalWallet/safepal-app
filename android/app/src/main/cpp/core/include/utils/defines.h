#ifndef WALLET_DEFINES_H
#define WALLET_DEFINES_H

#include <stddef.h>
#include <stdint.h>

#if defined(BUILD_FOR_WEB)

#ifndef _SSIZE_T
#define _SSIZE_T
typedef long        ssize_t;
#endif  /* _SSIZE_T */

#ifndef _U_INT8_T
#define _U_INT8_T
typedef unsigned char u_int8_t;
#endif  /* _SSIZE_T */

#endif

#if defined(BUILD_FOR_LOCAL_WALLET) || defined(BUILD_FOR_WEB)
typedef unsigned int HWND;
#endif

#define PASSWORD_MINI_LEN 6
#define PASSWORD_MAX_LEN 12
#define PASSWD_HASHED_LEN 32

#ifdef IOS

#ifndef IOS_APP
#define IOS_APP 1
#endif

#endif

#ifdef ANDROID

#ifndef ANDROID_APP
#define ANDROID_APP 1
#endif

#endif

#ifdef SAFEPAL

#ifndef SAFEPAL_DEV
#define SAFEPAL_DEV 1
#endif

#endif

#endif
