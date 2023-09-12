#include "protobuf_util.h"

int pb_encode32(uint32_t number, uint8_t buffer[10]) {
    if (number < 0x80) {
        buffer[0] = (uint8_t) number;
        return 1;
    }
    buffer[0] = (uint8_t) (number | 0x80);
    if (number < 0x4000) {
        buffer[1] = (uint8_t) (number >> 7);
        return 2;
    }
    buffer[1] = (uint8_t) ((number >> 7) | 0x80);
    if (number < 0x200000) {
        buffer[2] = (uint8_t) (number >> 14);
        return 3;
    }
    buffer[2] = (uint8_t) ((number >> 14) | 0x80);
    if (number < 0x10000000) {
        buffer[3] = (uint8_t) (number >> 21);
        return 4;
    }
    buffer[3] = (uint8_t) ((number >> 21) | 0x80);
    buffer[4] = (uint8_t) (number >> 28);
    return 5;
}

int pb_decode(uint8_t buffer[10], uint32_t *low, uint32_t *hi) {
    if (!(buffer[0] & 0x80)) {
        *low = buffer[0];
        if (hi) *hi = 0;
        return 1;
    }
    uint32_t r = buffer[0] & 0x7f;
    int i;
    for (i = 1; i < 4; i++) {
        r |= ((buffer[i] & 0x7f) << (7 * i));
        if (!(buffer[i] & 0x80)) {
            *low = r;
            if (hi) *hi = 0;
            return i + 1;
        }
    }
    uint64_t lr = 0;
    for (i = 4; i < 10; i++) {
        lr |= ((uint64_t) (buffer[i] & 0x7f) << (7 * (i - 4)));
        if (!(buffer[i] & 0x80)) {
            if (hi) *hi = (uint32_t) (lr >> 4);
            *low = r | (((uint32_t) lr & 0xf) << 28);
            return i + 1;
        }
    }
    *low = 0;
    if (hi) *hi = 0;
    return 10;
}
