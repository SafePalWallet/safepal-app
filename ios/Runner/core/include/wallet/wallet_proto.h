#ifndef _WALLET_WALLETPROTO_H
#define _WALLET_WALLETPROTO_H

#include <stdint.h>
#include "common_core.h"
#include "pbc.h"
#include "cstr.h"

#define proto_debug_show_pbytes(m, b) db_msg("%s:%d->%s",m, b->size, debug_bin_to_hex((const char *) b->bytes, b->size))
#define proto_debug_show_bytes(m, b) db_msg("%s:%d->%s",m, b.size, debug_bin_to_hex((const char *) b.bytes, b.size))

#ifdef __cplusplus
extern "C" {
#endif

enum {
    QR_MSG_UNKOWN = 0,

    QR_MSG_BIND_ACCOUNT_REQUEST = 0x2,
    QR_MSG_BIND_ACCOUNT_RESP = 0x3,

    QR_MSG_GET_PUBKEY_REQUEST = 0x4,
    QR_MSG_GET_PUBKEY_RESP = 0x5,

    QR_MSG_BITCOIN_SIGN_REQUEST = 0x6,
    QR_MSG_BITCOIN_SIGN_RESP = 0x7,

    QR_MSG_ETH_SIGN_REQUEST = 0x8,
    QR_MSG_ETH_SIGN_RESP = 0x9
};

typedef struct {
    const unsigned char *bytes;
    int size;
} ProtoBytes;

typedef struct {
    uint16_t type;
    uint16_t flag;
    uint16_t client_id;
    uint16_t p_total;
    unsigned int time;
    int time_zone;
    uint32_t account_id;
    struct pbc_rmessage *rmsg;
    cstring *data;
} ProtoClientMessage;

typedef struct {
    uint32_t amount; // 10^N
    const char *currency; // USD CNY
    const char *symbol; //
    uint64_t value;
} ExchangeRate;

typedef struct {
    int32_t curve;
    uint32_t depth;
    uint32_t child_num;
    uint32_t fingerprint;
    uint8_t chain_code[32];
    uint8_t public_key[33];
} PubHDNode;

typedef struct {
    int32_t type;
    const char *uname;
    const char *path;
} CoinInfo;

typedef struct {
    const char *client_unique_id;
    const char *client_name;
    ProtoBytes sec_random;
    int32_t version;
} BindAccountReq;

int proto_init_env(unsigned char *key);

const char *proto_msg_type_to_name(int type);

struct pbc_wmessage *proto_new_wmessage(const char *type_name);

void proto_delete_wmessage(struct pbc_wmessage *msg);

struct pbc_rmessage *proto_decode_message(const char *type_name, const unsigned char *data, size_t len);

void proto_client_message_clean(ProtoClientMessage *msg);

void proto_client_message_delete(ProtoClientMessage *msg);

int proto_get_bytes_i(struct pbc_rmessage *req, const char *key, ProtoBytes *bytes, int i);

int proto_get_bytes(struct pbc_rmessage *req, const char *key, ProtoBytes *bytes);

int proto_check_exchange(ExchangeRate *ex);

double proto_coin_real_value(int64_t coin_value, uint16_t decimals);

double proto_get_exchange_rate_value(ExchangeRate *ex);

double proto_coin_currency_value(ExchangeRate *ex, int64_t coin_value, uint16_t decimals);

const char *proto_get_money_symbol(ExchangeRate *ex);

int proto_rmsg_ExchangeRate(struct pbc_rmessage *req, ExchangeRate *msg);

int proto_rmsg_CoinInfo(struct pbc_rmessage *req, CoinInfo *msg, const char *key, int i);

int proto_rmsg_BindAccountReq(struct pbc_rmessage *req, BindAccountReq *msg);

#ifdef __cplusplus
}
#endif
#endif
