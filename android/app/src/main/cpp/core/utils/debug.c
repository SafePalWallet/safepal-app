#include <sys/time.h>
#include <time.h>
#include "debug.h"

#ifdef CONFIG_DEBUG_PERFORMANCE

long DEBUG_TESTTIME0 = 0;
long DEBUG_TESTTIME1 = 0;

#endif

#if CONFIG_LOG_TYPE == 2
static char debug_tiembuf[48];

const char *DebugThreadTime() {
    struct timeval realtime;
    struct tm localtime;

    gettimeofday(&realtime, NULL);
    localtime_r(&realtime.tv_sec, &localtime);

    snprintf(debug_tiembuf, sizeof(debug_tiembuf), "%02d-%02d %02d:%02d:%02d.%03ld ", localtime.tm_mon + 1, localtime.tm_mday,
             localtime.tm_hour, localtime.tm_min, localtime.tm_sec, realtime.tv_usec / 1000);
    return debug_tiembuf;
}

#endif

#if DB_LOG_LEVEL > 0

long long debugGetClockTime() {
    struct timeval realtime;
    gettimeofday(&realtime, NULL);
    long long mstime = realtime.tv_sec;
    if (mstime > 1514764800) mstime -= 1514764800;  //UTC 2018-01-01
    //ALOGD("tv_sec mstime:%lld tv_sec:%ld tv_usec:%ld", mstime, realtime.tv_sec, realtime.tv_usec);
    return mstime * 1000LL + realtime.tv_usec / 1000;
}

#define DEBUG_MAX_BIN_LEN 256
static char debug_hex_buf[2 * DEBUG_MAX_BIN_LEN + 4];
static const char hex_digits[] = "0123456789abcdef";

const char *debug_bin_to_hex(const char *bin_in, int size) {
    int dsize = (size > DEBUG_MAX_BIN_LEN) ? DEBUG_MAX_BIN_LEN : size;
    int i = 0;
    for (; i < dsize; i++) {
        debug_hex_buf[i * 2] = hex_digits[(bin_in[i] >> 4) & 0xF];
        debug_hex_buf[i * 2 + 1] = hex_digits[bin_in[i] & 0xF];
    }
    if (size > dsize) {
        debug_hex_buf[i * 2] = '.';
        debug_hex_buf[i * 2 + 1] = '.';
        i++;
    }
    debug_hex_buf[i * 2] = '\0';
    return debug_hex_buf;
}

const char *debug_ubin_to_hex(const unsigned char *bin_in, int size) {
    return debug_bin_to_hex((const char *) bin_in, size);
}

void debug_show_long_bin_data(const char *msg, const unsigned char *bin_in, int size) {
    int i = 0;
    int len;
    do {
        len = size - i;
        if (len > DEBUG_MAX_BIN_LEN) len = DEBUG_MAX_BIN_LEN;
        ALOGD("%s len:%d (%d - %d) -> %s", msg, size, i, i + len, debug_bin_to_hex((const char *) (bin_in + i), len));
        i += len;
    } while (i < size);
}

#endif