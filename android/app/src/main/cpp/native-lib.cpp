
#define LOG_TAG "native-lib.cpp"

#include <jni.h>
#include <time.h>
#include <ecdsa.h>
#include <secp256k1.h>
#include <base58.h>
#include <bip39.h>
#include <qr_pack.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <base32.h>
#include "crypto_utils.h"
#include "segwit_addr.h"
#include <cash_addr.h>
#include <memzero.h>
#include <core/crypto/address.h>
#include <core/crypto/curves.h>
#include "wallet_proto_qr.h"
#include "secure_util.h"

#define NATIVE_METHOD_SECTION __attribute__((section (".mytext")))
#define JNIREG_CLASS "io/safepal/example/JNICryptoUtils"

#define DEFINE_BYTE_ARRAY_BUFFER(x) const uint8_t * x##Bytes = (const uint8_t *) env->GetByteArrayElements(x, 0); size_t x##Len = env->GetArrayLength(x)
#define FREE_BYTE_ARRAY_BUFFER(x) if(x##Bytes) env->ReleaseByteArrayElements(x, (jbyte *) x##Bytes, 0)
#define DEFINE_STRING_BUFFER(x) const char * x##Str = (const char *)env->GetStringUTFChars(x, 0)
#define FREE_STRING_BUFFER(x) if(x##Str) env->ReleaseStringChars(x, (const jchar *)x##Str)

#ifdef ENABLE_EXPORT
#undef ENABLE_EXPORT
#endif
#define ENABLE_EXPORT 0

#if ENABLE_EXPORT
#define DEFINE_FUNC(type,name) JNIEXPORT type JNICALL Java_io_safepal_example_CryptoUtils_##name
#else
#define DEFINE_FUNC(type,name) NATIVE_METHOD_SECTION static type __##name
#endif


#ifdef __cplusplus
extern "C" {
#endif

static qr_packet _qr;
static qr_packet_buffer _buffer;

static const int kQrPackMaxSize = 250;

static int clearBuffer() {
    qr_packet *qr = &_qr;
    qr_packet_buffer *buffer = &_buffer;
    free_qr_buffer(buffer);
    free_qr_packet(qr);
    init_qr_packet(qr, 0);
    return 0;
}

static int getHDNodeFromJni(JNIEnv *env, HDNode *output, jint depth, jint childNum, jbyteArray chainCode, jbyteArray pubkey) {
    if (chainCode == nullptr || pubkey == nullptr) {
        return -1;
    }
    if (output == nullptr) {
        return  -1;
    }
    DEFINE_BYTE_ARRAY_BUFFER(chainCode);
    DEFINE_BYTE_ARRAY_BUFFER(pubkey);

    memzero(output, sizeof(HDNode));
    output->depth = depth;
    output->child_num = childNum;
    memcpy(output->public_key, pubkeyBytes, pubkeyLen);
    memcpy(output->chain_code, chainCodeBytes, chainCodeLen);

    FREE_BYTE_ARRAY_BUFFER(chainCode);
    FREE_BYTE_ARRAY_BUFFER(pubkey);
    return 0;
}

static jobject newObject(JNIEnv *env, const uint8_t *data, size_t size, const size_t code) {
    jclass cls = env->FindClass("io/safepal/example/JNIResp");
    jmethodID initMethodId = env->GetMethodID(cls, "<init>", "()V");
    jobject object = env->NewObject(cls, initMethodId);
    jfieldID codeFieldId = env->GetFieldID(cls, "code", "I");
    jfieldID dataFieldId = env->GetFieldID(cls, "data", "[B");
    env->SetIntField(object, codeFieldId, (jint)code);
    if (code >= 0 && data != nullptr && size > 0) {
        jbyteArray dataByteArray = env->NewByteArray(size);
        env->SetByteArrayRegion(dataByteArray, 0, size, (jbyte *)(data));
        env->SetObjectField(object, dataFieldId, dataByteArray);
    }
    return  object;
}

static int getHDNodeFromObject(JNIEnv *env, HDNode *output, jobject object) {
    if (object == nullptr || output == nullptr) {
        return -1;
    }
    jclass cls = env->FindClass("io/safepal/example/HDNode");
    output->depth = env->GetIntField(object, env->GetFieldID(cls, "depth", "I"));
    output->child_num = env->GetIntField(object, env->GetFieldID(cls, "childNum", "I"));

    jfieldID chainCodeFieldId = env->GetFieldID(cls, "chainCode", "[B");
    jbyteArray chainCode = (jbyteArray)env->GetObjectField(object, chainCodeFieldId);
    DEFINE_BYTE_ARRAY_BUFFER(chainCode);
    memcpy(output->chain_code, chainCodeBytes, chainCodeLen);

    jfieldID pubkeyFieldId = env->GetFieldID(cls, "pubKey", "[B");
    jbyteArray pubkey = (jbyteArray)env->GetObjectField(object, pubkeyFieldId);
    DEFINE_BYTE_ARRAY_BUFFER(pubkey);
    memcpy(output->public_key, pubkeyBytes, pubkeyLen);

    FREE_BYTE_ARRAY_BUFFER(chainCode);
    FREE_BYTE_ARRAY_BUFFER(pubkey);

    return  0;
}

static jobject newHDNodeObject(JNIEnv *env, const HDNode *node, int fingerprint) {
    jclass cls = env->FindClass("io/safepal/example/HDNode");
    jmethodID initMethodId = env->GetMethodID(cls, "<init>", "()V");
    jobject object = env->NewObject(cls, initMethodId);

    env->SetIntField(object, env->GetFieldID(cls, "depth", "I"), (jint)node->depth);
    env->SetIntField(object, env->GetFieldID(cls, "childNum", "I"), (jint)node->child_num);

    if (fingerprint != 0) {
        env->SetIntField(object, env->GetFieldID(cls, "fingerPrint", "I"), (jint)fingerprint);
    }

    jfieldID chainCodeFieldId = env->GetFieldID(cls, "chainCode", "[B");
    jbyteArray dataByteArray = env->NewByteArray(32);
    env->SetByteArrayRegion(dataByteArray, 0, 32, (jbyte *)(node->chain_code));
    env->SetObjectField(object, chainCodeFieldId, dataByteArray);

    jfieldID pubkeyFieldId = env->GetFieldID(cls, "pubKey", "[B");
    dataByteArray = env->NewByteArray(33);
    env->SetByteArrayRegion(dataByteArray, 0, 33, (jbyte *)(node->public_key));
    env->SetObjectField(object, pubkeyFieldId, dataByteArray);

    return  object;
}

DEFINE_FUNC(jbyteArray, getEcdsaPubKey) (JNIEnv *env, jclass classObject, jbyteArray byteArray, jint compress) {
    if (byteArray == nullptr) {
        return nullptr;
    }
    jboolean isCopy;
    jbyte *privateKey = env->GetByteArrayElements(byteArray, &isCopy);
    if (privateKey == nullptr) {
        return nullptr;
    }
    const ecdsa_curve *curve = &secp256k1;
    uint8_t pubKey[65] = {0};
    int pubKeyLen = 0;
    jbyteArray result;
    if (compress == 1) {
        pubKeyLen = 33;
        ecdsa_get_public_key33(curve, (uint8_t *)privateKey, pubKey);
    } else {
        pubKeyLen = 65;
        ecdsa_get_public_key65(curve, (uint8_t *) privateKey, pubKey);
    }
    result = env->NewByteArray(pubKeyLen);
    env->SetByteArrayRegion(result, 0, pubKeyLen, (const jbyte *) pubKey);
    env->ReleaseByteArrayElements(byteArray, privateKey, 0);
    return result;
}

DEFINE_FUNC(jstring, base58Encode) (JNIEnv *env, jclass classOjbect, jbyteArray data, jstring hash58Hasher) {
    jboolean isCopy;
    jbyte *dataBytes = env->GetByteArrayElements(data, &isCopy);
    char *str = nullptr;
    if (hash58Hasher != nullptr) {
       str  = (char *)env->GetStringUTFChars(hash58Hasher, &isCopy);
    }
    int hasherType = hasherTypeFromName(str);
    int dataLen = env->GetArrayLength(data);
    int ret = 0;
    char result[128] = {0};
    if (hasherType < 0) {
        size_t b58Sz = sizeof(result);
        b58enc(result, &b58Sz, dataBytes, dataLen);
        ret = b58Sz;
    } else {
        ret = base58_encode_check((const uint8_t *) dataBytes, dataLen, (HasherType)hasherType, result,
                                  sizeof(result));
    }
    env->ReleaseByteArrayElements(data, dataBytes, 0);
    if (str != nullptr) {
        env->ReleaseStringChars(hash58Hasher, (const jchar *)str);
    }
    jstring  address = nullptr;
    if (ret > 0) {
        address = env->NewStringUTF((const char *) result);
    }

    return address;
}

DEFINE_FUNC(jbyteArray, getAesKey)(JNIEnv *env, jclass classObject, jbyteArray pubKey, jbyteArray privateKey) {
    int pubLen = env->GetArrayLength(pubKey);
    const ecdsa_curve *curve = &secp256k1;
    const int len = 64;
    curve_point R;
    jboolean isCopy = false;
    jbyte *pubkeyBytes = env->GetByteArrayElements(pubKey, &isCopy);

    uint8_t pub[65] = {0};

    if (pubLen == 33) {
        ecdsa_uncompress_pubkey(curve, (const uint8_t *)pubkeyBytes, pub);
    } else if (pubLen == 65) {
        memcpy(pub, pubkeyBytes, sizeof(pub));
    } else {
        return nullptr;
    }

    bn_read_be((const uint8_t *) pub + 1, &R.x);
    bn_read_be((const uint8_t *) pub + 33, &R.y);
    if (!ecdsa_validate_pubkey(curve, &R)) {
        env->ReleaseByteArrayElements(pubKey, pubkeyBytes, 0);
        return nullptr;
    }

    bignum256 k;
    isCopy = false;
    jbyte *privateBytes = env->GetByteArrayElements(privateKey, &isCopy);
    bn_read_be((uint8_t *) privateBytes, &k);
    point_multiply(curve, &k, &R, &R);

    uint8_t x[32];
    bn_write_be(&R.x, x);

    jbyteArray result = env->NewByteArray(32);
    env->SetByteArrayRegion(result, 0, 32, (const jbyte *) x);

    env->ReleaseByteArrayElements(pubKey, pubkeyBytes, 0);
    env->ReleaseByteArrayElements(privateKey, privateBytes, 0);

    return result;
}

DEFINE_FUNC(jint, getQrPacketType) (JNIEnv *env, jclass classObject, jbyteArray qrData) {
    jboolean isCopy = false;
    jint qrDataLen = env->GetArrayLength(qrData);
    jbyte *bytes = env->GetByteArrayElements(qrData, &isCopy);
    int qrType = is_bin_qr_packet((const char *)bytes, qrDataLen);
    env->ReleaseByteArrayElements(qrData, bytes, 0);
    return qrType;
}


static void getLocalTime(uint32_t *outputTime, int16_t *outputZone) {
    time_t tm_t;
    time(&tm_t);
    struct  tm _tmStr;
    struct  tm *tmStr = &_tmStr;
    memzero(tmStr, sizeof(struct tm));
    localtime_r(&tm_t, tmStr);
    int16_t zone = (int16_t)(tmStr->tm_gmtoff / 60);

    zone = htons(zone);

    uint32_t time = 0;
    time = htonl((uint32_t)tm_t);

    if (outputTime != nullptr) {
        *outputTime = time;
    }
    if (outputZone != nullptr) {
        *outputZone = zone;
    }
}

DEFINE_FUNC(jobjectArray, splitQrData)
        (
        JNIEnv *env,
        jclass classObject,
        jbyteArray qrdata,
        jint  msgType,
        jint clientId,
        jbyteArray aesKey,
        jbyteArray exHeader,
        jboolean base64,
        jboolean crypto,
        jint version
        ) {
    // time 4 bytes + 2 time zone
    if (qrdata == nullptr) {
        return nullptr;
    }
    const int timeLen = 6;
    int qrDataLen = env->GetArrayLength(qrdata);
    size_t  exHeaderLen = 0;
    if (exHeader != nullptr) {
        exHeaderLen = (const size_t)env->GetArrayLength(exHeader);
    }

    int totalLen = timeLen + qrDataLen + exHeaderLen;

    uint8_t *data = (uint8_t *)malloc(totalLen);
    if (data == nullptr) {
        return nullptr;
    }
    memzero(data, totalLen);
    uint8_t  *_dataPtr = data;

    uint32_t time = 0;
    int16_t zone = 0;
    getLocalTime(&time, &zone);
    memcpy(_dataPtr, &time, 4);
    _dataPtr += 4;
    memcpy(_dataPtr, &zone, 2);
    _dataPtr += 2;

    jboolean isCopy = false;
    const uint8_t *exHeaderBytes;
    jbyte *qrdataBytes;
    if (exHeader != nullptr) {
        exHeaderBytes = (const uint8_t *)env->GetByteArrayElements(exHeader, &isCopy);
        memcpy(_dataPtr, exHeaderBytes, exHeaderLen);
        _dataPtr += exHeaderLen;
    }
    if (qrdata != nullptr) {
        qrdataBytes = env->GetByteArrayElements(qrdata, &isCopy);
        memcpy(_dataPtr, qrdataBytes, qrDataLen);
        _dataPtr += qrDataLen;
    }

    int flag = 0;
    flag |= QR_FLAG_HAS_TIME;
    if (crypto) {
        flag |= QR_FLAG_CRYPT_AES;
    }
    if (exHeader != nullptr) {
        flag |= QR_FLAG_EXT_HEADER;
    }

    int qrType = QR_TYPE_BIN;
    if (base64) {
        qrType = QR_TYPE_B64;
    }

    qr_packet_chunk_info *chunk_info = (qr_packet_chunk_info *)malloc(sizeof(qr_packet_chunk_info));
    memzero(chunk_info, sizeof(qr_packet_chunk_info));
    jbyte *aesBytes = nullptr;
    if (aesKey != nullptr) {
        isCopy = false;
        aesBytes = env->GetByteArrayElements(aesKey, &isCopy);
    }
    split_qr_packet(chunk_info,
                    (const unsigned char *)data,
                    totalLen,
                    qrType,
                    (int)msgType,
                    flag,
                    clientId,
                    (const unsigned char *)aesBytes,
                    kQrPackMaxSize);
    jbyteArray byteArray = env->NewByteArray(1);
    jclass objectCls = env->GetObjectClass(byteArray);
    jobjectArray results = env->NewObjectArray(chunk_info->total, objectCls, nullptr);

    for (int i = 0; i < chunk_info->total; ++i) {
        qr_packet_chunk_slice *slice = (chunk_info->chunks + i);
        jbyteArray bytes = env->NewByteArray(slice->size);
        env->SetByteArrayRegion(bytes, 0, slice->size, (jbyte *)slice->data);
        env->SetObjectArrayElement(results, i, bytes);
    }
    free_qr_packet_chunk(chunk_info);
    free(chunk_info);
    memzero(data, totalLen);
    free(data);

    if (qrdataBytes != nullptr) {
        env->ReleaseByteArrayElements(qrdata, qrdataBytes, 0);
    }
    if (aesBytes != nullptr) {
        env->ReleaseByteArrayElements(aesKey, aesBytes, 0);
    }
    if (exHeader != nullptr) {
        env->ReleaseByteArrayElements(exHeader, (jbyte *)exHeaderBytes, 0);
    }

    return results;
}

DEFINE_FUNC(jint, clearBuffer) (JNIEnv *env, jclass classObject) {
    return clearBuffer();
}

DEFINE_FUNC(jbyteArray, getExtHeaderData) (JNIEnv *env, jclass classObject) {
    qr_packet *qr = &_qr;
    jbyteArray bytes = nullptr;
    int len = qr_packet_ext_header_length(qr);
    if (len <= 0) {
        return nullptr;
    }
    if (!(qr->flag & QR_FLAG_EXT_HEADER)) {
        return nullptr;
    }
    const unsigned char *data = qr_packet_ext_header_str(qr, len);
    bytes = env->NewByteArray(len);
    env->SetByteArrayRegion(bytes, 0, len, (const jbyte *)data);
    return bytes;
}

DEFINE_FUNC(jbyteArray, decrypQrData)(JNIEnv *env, jclass classObject, jbyteArray aesKey) {
    qr_packet *qr = &_qr;
    jbyteArray bytes = nullptr;
    if (qr->flag & QR_FLAG_CRYPT_AES) {
        if (aesKey == nullptr) {
            ALOGD("aes key is null");
            return nullptr;
        }
        jboolean isCopy;
        jbyte *aes = env->GetByteArrayElements(aesKey, &isCopy);
        int result = decrypt_qr_packet(qr, (const unsigned char *)aes);
        if (result != 0) {
            env->ReleaseByteArrayElements(aesKey, aes, 0);
            return nullptr;
        }
        if (verify_qr_packet(qr)) {
            env->ReleaseByteArrayElements(aesKey, aes, 0);
            return nullptr;
        }
        env->ReleaseByteArrayElements(aesKey, aes, 0);
    }
    if (qr->data == nullptr) {
        return nullptr;
    }
    int dataLen = qr->data->len;
    if (qr->p_total > 1) {
        dataLen = dataLen - 4;
    }
    bytes = env->NewByteArray(dataLen);
    env->SetByteArrayRegion(bytes, 0, dataLen, (const jbyte *)qr->data->str);
    return bytes;
}

DEFINE_FUNC(jint, getQrPacketCount) (JNIEnv *env, jclass classObject) {
    qr_packet *qr = &_qr;
    return qr->p_total;
}

DEFINE_FUNC(jint, getQrPacketProgress) (JNIEnv *env, jclass classObject) {
    qr_packet *qr = &_qr;
    return qr->p_index;
}

DEFINE_FUNC(jint, getMessageType) (JNIEnv *env, jclass classObject) {
    qr_packet *qr = &_qr;
    return qr->type;
}

DEFINE_FUNC(jint, mergeQrPacketBuffer) (
        JNIEnv *env, jclass classObject, jbyteArray qrData) {
    qr_packet *qr = &_qr;
    qr_packet_buffer *buffer = &_buffer;
    jboolean isCopy;
    jbyte *bytes = env->GetByteArrayElements(qrData, &isCopy);
    jint dataLen = env->GetArrayLength(qrData);
    jint ret = merge_qr_packet_buffer(buffer, qr, (const char *)bytes, dataLen);
    env->ReleaseByteArrayElements(qrData, bytes, 0);
    return ret;
}

DEFINE_FUNC(jbyteArray, sha256) (JNIEnv *env, jclass classObject, jbyteArray data) {
    jboolean isCopy;
    jbyte *bytes = env->GetByteArrayElements(data, &isCopy);
    jint  dataLen = env->GetArrayLength(data);
    uint8_t digest[SHA256_DIGEST_LENGTH] = {0};
    sha256_Raw((const uint8_t *)bytes, dataLen, digest);

    env->ReleaseByteArrayElements(data, bytes, 0);

    jbyteArray results = env->NewByteArray(SHA256_DIGEST_LENGTH);
    env->SetByteArrayRegion(results, 0, SHA256_DIGEST_LENGTH, (const jbyte *)digest);
    return  results;
}

DEFINE_FUNC(jbyteArray, ecdsaUncompressPubkey) (JNIEnv *env, jclass classObject, jbyteArray data) {
    jboolean isCopy;
    jbyte *bytes = env->GetByteArrayElements(data, &isCopy);
    uint8_t buf[65] = {0};
    const curve_info *info = &secp256k1_info;
    ecdsa_uncompress_pubkey(info->params, (const uint8_t *)(bytes), buf);
    jbyteArray results = env->NewByteArray(65);
    env->SetByteArrayRegion(results, 0, 65, (const jbyte *)buf);
    env->ReleaseByteArrayElements(data, bytes, 0);
    return  results;
}

DEFINE_FUNC(jstring, bech32AddressEncode) (JNIEnv *env, jclass  classObject, jbyteArray data, jstring hrp) {
    jboolean isCopy;
    jbyte *bytes = env->GetByteArrayElements(data, &isCopy);
    jint  dataLen = env->GetArrayLength(data);
    const char *hrpStr = env->GetStringUTFChars(hrp, &isCopy);

    char result[128] = {0};
    int ret = bech32_addr_encode(result, hrpStr, (uint8_t *)bytes, 20);
    env->ReleaseByteArrayElements(data, bytes, 0);
    env->ReleaseStringUTFChars(hrp, hrpStr);
    if (!ret) {
        return nullptr;
    }
    return env->NewStringUTF(result);
}

DEFINE_FUNC(jbyteArray, bech32AddressDecode) (JNIEnv *env, jclass  classObject, jstring  address, jstring hrp) {
    jboolean isCopy = false;
    const char *addressStr = env->GetStringUTFChars(address, &isCopy);
    const char *hrpStr = nullptr;
    if (hrp != nullptr) {
        hrpStr = env->GetStringUTFChars(hrp, &isCopy);
    }

    size_t  resultsLen = 0;
    uint8_t results[20] = {0};
    int ret = bench32DecodeAddr((const uint8_t *)addressStr, strlen(addressStr), results, &resultsLen, hrpStr);
    jbyteArray bytesArray = nullptr;
    if (ret) {
        bytesArray = env->NewByteArray(resultsLen);
        env->SetByteArrayRegion(bytesArray, 0, resultsLen, (jbyte *)results);
    }

    env->ReleaseStringUTFChars(address, addressStr);
    env->ReleaseStringUTFChars(hrp, hrpStr);

    return bytesArray;
}

DEFINE_FUNC(jstring, getHDNodeXpub) (
        JNIEnv *env, jclass classObject,
        jint depth,
        jint childNum,
        jint fingerprint,
        jbyteArray chainCode,
        jbyteArray pubKey,
        jstring curve,
        jint magic
) {
    jboolean isCopy = false;
    const char *curveName = env->GetStringUTFChars(curve, &isCopy);

    HDNode hdNode;
    getHDNodeFromJni(env, &hdNode, depth, childNum, chainCode, pubKey);

    char result[128] = {0};
    int ret = getHDNodeXpub(&hdNode, curveName, magic, fingerprint, result, sizeof(result));

    if (curveName != nullptr) {
        env->ReleaseStringUTFChars(curve, curveName);
    }

    if (ret < 0) {
        return  nullptr;
    }
    return env->NewStringUTF(result);
}

DEFINE_FUNC(jbyteArray, base58Decode) (JNIEnv *env, jclass classObject, jstring address, jstring hasher, jint  desLen
) {
    jboolean isCopy = false;

    const char *addressStr = env->GetStringUTFChars(address, &isCopy);
    const char *hasherStr = nullptr;
    if (hasher != nullptr) {
        hasherStr = env->GetStringUTFChars(hasher, &isCopy);
    }

    size_t  resultLen = desLen;
    if (desLen <= 0) {
        resultLen = 128;
    }
    uint8_t results[resultLen];
    int ret = base58Decode(addressStr, results, &resultLen, hasherStr);
    env->ReleaseStringUTFChars(address, addressStr);
    if (hasher != nullptr) {
        env->ReleaseStringUTFChars(hasher, hasherStr);
    }
    jbyteArray byteArray = nullptr;
    if (ret) {
        byteArray = env->NewByteArray(resultLen);
        env->SetByteArrayRegion(byteArray, 0, resultLen, (const jbyte *)results);
    }

    return byteArray;
}

DEFINE_FUNC(jbyteArray, segwitAddressDecode) (JNIEnv *env, jclass  classObject, jstring  address, jstring  hrp) {
    jboolean isCopy = false;
    const char *addressStr = (char *)env->GetStringUTFChars(address, &isCopy);
    const char *hrpStr = (char *)env->GetStringUTFChars(hrp, &isCopy);
    uint8_t results[128] = {0};
    int version = 0;
    size_t progLen = 0;
    jbyteArray  byteArray = nullptr;
    int ret = segwit_addr_decode(&version, results, &progLen, hrpStr, addressStr);
    if (ret) {
        byteArray = env->NewByteArray(progLen);
        env->SetByteArrayRegion(byteArray, 0, progLen, (const jbyte *)results);
    }

    env->ReleaseStringUTFChars(address, addressStr);
    env->ReleaseStringUTFChars(hrp, hrpStr);
    return byteArray;
}

DEFINE_FUNC(jstring, getHDNodeSegwitAddress) (
        JNIEnv *env, jclass classObject,
        jint depth,
        jint childNum,
        jint fingerprint,
        jbyteArray chainCode,
        jbyteArray pubKey,
        jint change,
        jint index,
        jint version,
        jstring curve,
        jstring hrp,
        jint singleKey
) {
    jboolean isCopy = false;
    const char *curveName = env->GetStringUTFChars(curve, &isCopy);
    const curve_info *curveInfo = get_curve_by_name(curveName);
    if (curveInfo == nullptr) {
        env->ReleaseStringUTFChars(curve, curveName);
        return nullptr;
    }

    HDNode hdNode;
    getHDNodeFromJni(env, &hdNode, depth, childNum, chainCode, pubKey);

    const char *hrpStr = env->GetStringUTFChars(hrp, &isCopy);
    char result[128] = {0};
    int ret = segwitAddrEncode(result, sizeof(result), &hdNode, curveName, index, change, hrpStr, version, singleKey);
    env->ReleaseStringUTFChars(hrp, hrpStr);
    env->ReleaseStringUTFChars(curve, curveName);

    if (ret < 0) {
        return nullptr;
    }
    return env->NewStringUTF(result);
}

DEFINE_FUNC(jstring, getHDNodeBitcoinAddress) (
        JNIEnv *env, jclass classObject,
        jint depth,
        jint childNum,
        jbyteArray chainCode,
        jbyteArray pubKey,
        jstring curve,
        jint prefix,
        jint changeIndex,
        jint index,
        jint characterSet,
        jint purpose,
        jint singleKey
        ) {
    jboolean isCopy = false;
    const char *curveName = env->GetStringUTFChars(curve, &isCopy);
    HDNode hdNode;
    getHDNodeFromJni(env, &hdNode, depth, childNum, chainCode, pubKey);
    char results[128] = {0};
    size_t resultsLen = sizeof(results);
    int ret = getHDNodeBitcoinAddress(&hdNode, changeIndex, index, curveName, prefix, characterSet, purpose, results, resultsLen, singleKey);
    jstring address = nullptr;
    if (ret >= 0) {
        address = env->NewStringUTF(results);
    }
    if (curveName != nullptr) {
        env->ReleaseStringUTFChars(curve, curveName);
    }
    return address;
}

DEFINE_FUNC(jboolean, checkEthAddress) (JNIEnv *env, jclass classObject, jstring address) {
    jboolean  isCopy;
    const char *addressStr = env->GetStringUTFChars(address, &isCopy);
    int ret = checkEthAddr(addressStr, strlen(addressStr));
    env->ReleaseStringUTFChars(address, addressStr);
    if (ret <= 0) {
        return false;
    }
    return true;
}

DEFINE_FUNC(jbyteArray, aes256CFBEncrypt) (JNIEnv *env, jclass classObject, jbyteArray data, jbyteArray  key) {
    jboolean isCopy;
    jbyte *dataBytes = env->GetByteArrayElements(data, &isCopy);
    jint  dataLen = env->GetArrayLength(data);
    jbyte  *keyBytes = env->GetByteArrayElements(key, &isCopy);

    int ret = 0;
    unsigned  char *result = (unsigned char *)malloc(dataLen);
    if (result == nullptr) {
        env->ReleaseByteArrayElements(data, dataBytes, 0);
        env->ReleaseByteArrayElements(key, keyBytes, 0);
        return nullptr;
    }
    memzero(result, dataLen);

    ret = aes256_encrypt((const unsigned char *)dataBytes, result, dataLen, (const unsigned char *)keyBytes);
    jbyteArray byteArray = nullptr;
    if (ret == EXIT_SUCCESS) {
        byteArray = env->NewByteArray(dataLen);
        env->SetByteArrayRegion(byteArray, 0, dataLen, (jbyte *)result);
    }

    env->ReleaseByteArrayElements(data, dataBytes, 0);
    env->ReleaseByteArrayElements(key, keyBytes, 0);
    free(result);

    return byteArray;
}

DEFINE_FUNC(jbyteArray, aes256CFBDecrypt) (JNIEnv *env, jclass classObject, jbyteArray data, jbyteArray  key) {
    jboolean isCopy;
    jbyte *dataBytes = env->GetByteArrayElements(data, &isCopy);
    jint  dataLen = env->GetArrayLength(data);
    jbyte  *keyBytes = env->GetByteArrayElements(key, &isCopy);

    int ret = 0;
    unsigned  char *result = (unsigned char *)malloc(dataLen);
    if (result == nullptr) {
        env->ReleaseByteArrayElements(data, dataBytes, 0);
        env->ReleaseByteArrayElements(key, keyBytes, 0);
        return nullptr;
    }
    memzero(result, dataLen);

    ret = aes256_decrypt((const unsigned char *)dataBytes, result, dataLen, (const unsigned char *)keyBytes);
    jbyteArray byteArray = nullptr;
    if (ret == EXIT_SUCCESS) {
        byteArray = env->NewByteArray(dataLen);
        env->SetByteArrayRegion(byteArray, 0, dataLen, (jbyte *)result);
    }

    env->ReleaseByteArrayElements(data, dataBytes, 0);
    env->ReleaseByteArrayElements(key, keyBytes, 0);
    free(result);

    return byteArray;
}

DEFINE_FUNC(jobject, getChildHDNode) (JNIEnv *env, jclass clsssObject, jobject hdnode, jstring curve, jint childIndex) {
    HDNode output;
    memzero(&output, sizeof(HDNode));
    int ret = getHDNodeFromObject(env, &output, hdnode);
    if (ret < 0) {
        return  nullptr;
    }
    DEFINE_STRING_BUFFER(curve);
    ret = getChildHdnode(&output, curveStr, childIndex, 0);
    if (ret < 0) {
        return  nullptr;
    }
    FREE_STRING_BUFFER(curve);
    return  newHDNodeObject(env, &output, 0);
}

DEFINE_FUNC(jstring , ethereumAddressChecksum) (JNIEnv *env, jclass classObject, jbyteArray data) {
    if (data == nullptr) {
        return nullptr;
    }
    DEFINE_BYTE_ARRAY_BUFFER(data);
    char result[43] = {0};
    result[0] = '0';
    result[1] = 'x';
    ethereum_address_checksum((const uint8_t *)dataBytes, result + 2, false, 0);
    FREE_BYTE_ARRAY_BUFFER(data);
    jstring address = env->NewStringUTF((const char *) result);
    return address;
}

DEFINE_FUNC(jstring, getEthAddressForNode) (
        JNIEnv *env, jclass classObject,
        jint depth,
        jint childNum,
        jbyteArray chainCode,
        jbyteArray pubkey
) {
    if (pubkey == nullptr) {
        return nullptr;
    }
    HDNode node;
    int ret = getHDNodeFromJni(env, &node, depth, childNum, chainCode, pubkey);
    if (ret < 0) {
        return nullptr;
    }
    char results[128] = {0};
    ret = ethAddrForNode(&node, results, sizeof(results));
    if (ret < 0) {
        return nullptr;
    }
    return env->NewStringUTF(results);
}

#if !ENABLE_EXPORT
static JNINativeMethod gMethods[] = {
        { "getEcdsaPubKey", "([BI)[B", (void *)__getEcdsaPubKey},
        { "base58Encode", "([BLjava/lang/String;)Ljava/lang/String;", (void *)__base58Encode},
        { "getAesKey", "([B[B)[B", (void *)__getAesKey},

        { "splitQrData", "([BII[B[BZZI)[[B", (void *)__splitQrData},
        { "decrypQrData", "([B)[B", (void*)__decrypQrData},
        { "getQrPacketType", "([B)I", (void*)__getQrPacketType},
        { "mergeQrPacketBuffer", "([B)I", (void*)__mergeQrPacketBuffer},
        { "getQrPacketCount", "()I", (void*)__getQrPacketCount},
        { "getQrPacketProgress", "()I", (void*)__getQrPacketProgress},
        { "getMessageType", "()I", (void*)__getMessageType},
        { "clearBuffer", "()I", (void*)__clearBuffer},
        { "getExtHeaderData", "()[B", (void*)__getExtHeaderData},

        { "sha256", "([B)[B", (void*)__sha256},

        { "ecdsaUncompressPubkey", "([B)[B", (void*)__ecdsaUncompressPubkey},

        { "base58Decode", "(Ljava/lang/String;Ljava/lang/String;II)[B", (void*)__base58Decode},

        { "bech32AddressEncode", "([BLjava/lang/String;)Ljava/lang/String;", (void*)__bech32AddressEncode},
        { "bech32AddressDecode", "(Ljava/lang/String;Ljava/lang/String;)[B", (void*)__bech32AddressDecode},
        { "segwitAddressDecode", "(Ljava/lang/String;Ljava/lang/String;)[B", (void*)__segwitAddressDecode},

        { "getHDNodeXpub", "(III[B[BLjava/lang/String;I)Ljava/lang/String;", (void*)__getHDNodeXpub},

        { "getHDNodeBitcoinAddress", "(II[B[BLjava/lang/String;IIIIII)Ljava/lang/String;", (void*)__getHDNodeBitcoinAddress},
        { "getHDNodeSegwitAddress", "(III[B[BIIILjava/lang/String;Ljava/lang/String;I)Ljava/lang/String;", (void*)__getHDNodeSegwitAddress},

        { "checkEthAddress", "(Ljava/lang/String;)Z", (void*)__checkEthAddress},
        { "getEthAddressForNode", "(II[B[B)Ljava/lang/String;", (void*)__getEthAddressForNode},

        { "aes256CFBEncrypt", "([B[B)[B", (void*)__aes256CFBEncrypt},
        { "aes256CFBDecrypt", "([B[B)[B", (void*)__aes256CFBDecrypt},

        { "getChildNode", "(Lio/safepal/example/HDNode;Ljava/lang/String;I)Lio/safepal/example/HDNode;", (void *)__getChildHDNode},
        {"ethereumAddressChecksum", "([B)Ljava/lang/String;", (void *)__ethereumAddressChecksum},
};

static int registerNativeMethods(JNIEnv* env, const char* className, JNINativeMethod* gMethods, int numMethods) {
    jclass clazz;
    clazz = (env)->FindClass(className);
    if (clazz == nullptr) {
        return JNI_FALSE;
    }
    if ((env)->RegisterNatives(clazz, gMethods, numMethods) < 0) {
        return JNI_FALSE;
    }
    return JNI_TRUE;
}

static int registerNatives(JNIEnv* env) {
    if (!registerNativeMethods(env, JNIREG_CLASS, gMethods, sizeof(gMethods) / sizeof(gMethods[0]))) {
        return JNI_FALSE;
    }
    return JNI_TRUE;
}

jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    JNIEnv* env = nullptr;
    jint result = -1;
    if ((vm)->GetEnv( (void**) &env, JNI_VERSION_1_4) != JNI_OK) {
        return -1;
    }
    if (!registerNatives(env)) {
        return -1;
    }
    result = JNI_VERSION_1_4;
    return result;
}
#endif


#ifdef __cplusplus
}
#endif
