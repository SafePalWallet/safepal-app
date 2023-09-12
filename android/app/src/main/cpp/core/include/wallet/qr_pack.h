#ifndef WALLET_QR_PACK_H
#define WALLET_QR_PACK_H

#ifdef __cplusplus
extern "C" {
#endif

#include "cstr.h"

#define QRCODE_PREFIX_LEN 2

#define QR_FLAG_CRYPT_AES 0x1
#define QR_FLAG_HAS_TIME 0x2
#define QR_FLAG_EXT_HEADER 0x4

#define MAX_QR_BUFFER_SIZE 256

enum {
    QR_TYPE_BIN = 0,
    QR_TYPE_B64 = 1,
};

typedef enum {
    QR_DECODE_SUCCESS = 0,
    QR_DECODE_SYSTEM_ERR = -1,
    QR_DECODE_PACKET_FAILED = -101,
    QR_DECODE_UNKOWN_CLIENT = -102,
    QR_DECODE_INVALID_HASH_CHECK = -103,
    QR_DECODE_OVER_BUFF_SIZE = -104,
    QR_DECODE_INVALID_DATA = -105,
    QR_DECODE_ACCOUNT_MISMATCH = -106,
    QR_DECODE_UNSUPPORT_MSG = -107,
    QR_DECODE_INVALID_MSG = -108,
} QR_DECODE;

typedef struct {
    uint16_t type;
    uint16_t p_total;
    uint16_t p_index;
    uint16_t flag;
    uint16_t client_id;
    cstring *data;
} qr_packet;

typedef struct {
    uint16_t type;
    uint16_t p_total;
    uint16_t client_id;
    cstring *chunks[MAX_QR_BUFFER_SIZE];
} qr_packet_buffer;

#pragma pack(1)
typedef struct {
    unsigned char nbit;
    unsigned char type;
    unsigned char flag;
    unsigned char client_id;
    unsigned char checkcode[4]; //hash256(data)
    uint16_t length;        //2byte
} qr_packet_header;

typedef struct {
    unsigned char p_total;
    unsigned char p_index;
} qr_packet_chunk_header;

#pragma pack()

typedef struct {
    unsigned int time;
    int time_zone;
    uint32_t account_id;
} qr_packet_ext_header;

typedef struct {
    int size;
    unsigned char *data;
} qr_packet_chunk_slice;

typedef struct {
    int total;
    qr_packet_chunk_slice *chunks;
} qr_packet_chunk_info;

extern void init_qr_packet(qr_packet *p, unsigned int data_size);

void free_qr_packet(qr_packet *p);

int qr_packet_ext_header_length(const qr_packet *p);

const unsigned char *qr_packet_ext_header_str(const qr_packet *p, int ext_header_len);

int qr_packet_data_length(const qr_packet *p, int ext_header_len);

const unsigned char *qr_packet_data_str(const qr_packet *p, int ext_header_len);

int set_qr_packet(qr_packet *p, const char *data, size_t size);

int free_qr_buffer(qr_packet_buffer *buffer);

int is_bin_qr_packet(const char *data, size_t size);

int decode_qr_packet(const char *data, size_t size, qr_packet *packet);

int merge_qr_packet_buffer(qr_packet_buffer *buffer, qr_packet *mrg_pkt, const char *data, size_t size);

int decrypt_qr_packet(qr_packet *mrg_pkt, const unsigned char *sekey);

int verify_qr_packet(qr_packet *pkt);

int get_qr_packet_header_len(int have_chunk);

int split_qr_packet(qr_packet_chunk_info *chunk_result, const unsigned char *qrdata, int size, int qrtype, int msg_type, int flag,
                    int client_id, const unsigned char *sekey, int max_chunk_size);

int free_qr_packet_chunk(qr_packet_chunk_info *chunk_result);

#ifdef __cplusplus
}
#endif

#endif

