#include "crc16.h"

uint16_t crc16(uint8_t *bytes, int length) {
    // Calculate checksum for existing bytes
    uint16_t crc = 0x0000;
    uint16_t polynomial = 0x1021;

    for (int i = 0; i < length; i++) {
        uint8_t byte = bytes[i];
        for (int bitidx = 0; bitidx < 8; bitidx++) {
            uint8_t bit = ((byte >> (7 - bitidx) & 1) == 1);
            uint8_t c15 = ((crc >> 15 & 1) == 1);
            crc <<= 1;
            if (c15 ^ bit) {
                crc ^= polynomial;
            }
        }
    }
    return crc & 0xffff;
}