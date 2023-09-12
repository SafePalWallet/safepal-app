#ifndef _WALLET_WALLETPROTO_QR_H
#define _WALLET_WALLETPROTO_QR_H

#include "wallet_proto.h"
#include "qr_pack.h"

#ifdef __cplusplus
extern "C" {
#endif

struct pbc_rmessage *proto_decode_packet_message(qr_packet *packet);

ProtoClientMessage *proto_decode_client_message(qr_packet *packet);

cstring *proto_client_message_serialize(const ProtoClientMessage *msg);

ProtoClientMessage *proto_client_message_unserialize(const unsigned char *data, int size);

#ifdef __cplusplus
}
#endif
#endif
