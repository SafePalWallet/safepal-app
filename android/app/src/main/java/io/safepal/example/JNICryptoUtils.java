package io.safepal.example;

public class JNICryptoUtils {
    static {
        System.loadLibrary("wallet_core");
    }

    public static native byte[] getRandomData(int len);
    public static native byte[] getEcdsaPubKey(byte[] key, int compress);
    public static native String base58Encode(byte[] data, String hash58Hasher);
    public static native byte[] getAesKey(byte[] pubKey, byte[] privateKey);

    // qr code relative api
    public static native byte[][] splitQrData(byte[] qrdata,
                                              int msgType,
                                              int clientId,
                                              byte[]aesKey,
                                              byte[] exHeader,
                                              boolean base64,
                                              boolean crypto,
                                              int version);

    public static native byte[] decrypQrData(byte[] aesKey);
    public static native int getQrPacketType(byte[] qrData); // 0 common qr;1 bin;2 base 64
    public static native int mergeQrPacketBuffer(byte[] qrData);
    public static native int getQrPacketCount();
    public static native int getQrPacketProgress();
    public static native int getMessageType();
    public static native int clearBuffer();
    public static native byte[] getExtHeaderData();

    public static native byte[] sha256(byte[] data);

    public static native byte[] ecdsaUncompressPubkey(byte[] compressPubkey);

    public static native byte[] base58Decode(String address, String hasher, int characterSet, int desLen);

    public static native String bech32AddressEncode(byte[] data, String hrp);
    public static native byte[] bech32AddressDecode(String address, String hrp);

    public static native byte[] segwitAddressDecode(String address, String hrp);

    public static native String getHDNodeXpub(
            int depth,
            int childNum,
            int fingerprint,
            byte[] chainCode,
            byte[] pubKey,
            String curve,
            int magic
    );

    public static native String getHDNodeBitcoinAddress(
            int depth,
            int childNum,
            byte[] chainCode,
            byte[] pubKey,
            String curve,
            int prefix,
            int changeIndex,
            int index,
            int characterSet,
            int purpose,
            int singleKey
    );

    public static native String getHDNodeSegwitAddress(
            int depth,
            int childNum,
            int fingerprint,
            byte[] chainCode,
            byte[] pubKey,
            int change,
            int index,
            int version,
            String curve,
            String hrp,
            int singleKey
            );

    public static native String getCoinAddress(
            int depth,
            int childNum,
            int fingerprint,
            byte[] chainCode,
            byte[] pubKey,
            int change,
            int index,
            int version,
            String curve,
            String hrp,
            String uname,
            int type,
            int singleKey
    );

    public static native boolean checkEthAddress(
            String address
    );

    public static native byte[] aes256CFBEncrypt(
            byte[] data,
            byte[] key
    );

    public static native byte[] aes256CFBDecrypt(
            byte[] data,
            byte[] key
    );

    public static  native HDNode getChildNode(HDNode node, String curve, int childIndex);

    public static native String getEthAddressForNode(
            int depth,
            int childNum,
            byte[] chainCode,
            byte[] pubKey);

    public static native String ethereumAddressChecksum(byte[] bin);
}
