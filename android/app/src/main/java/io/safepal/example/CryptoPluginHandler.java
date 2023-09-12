package io.safepal.example;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CryptoPluginHandler {

    static public HashMap createHashMap(JNIResp resp) {
        if (resp == null) {
            return null;
        }
        @SuppressWarnings("unchecked")
        HashMap<String, Object> map = new HashMap();
        map.put("code", resp.code);
        map.put("data", resp.data);
        return map;
    }

    static public HDNode toHDNodeFromMap(Map<String, Object> data) {
        @SuppressWarnings("unchecked")
        Number depth = (Number) data.get("depth");
        byte[] pubKey = (byte[]) data.get("publicKey");
        byte[] chainCode = (byte[]) data.get("chainCode");
        Number childNum = (Number) data.get("childNum");
        Number fingprint = (Number)data.get("fingerprint");
        HDNode hdNode = new HDNode();
        hdNode.depth = depth.intValue();
        hdNode.pubKey = pubKey;
        hdNode.childNum = childNum.intValue();
        hdNode.chainCode = chainCode;
        if (fingprint != null) {
            hdNode.fingerPrint = fingprint.intValue();
        }
        return  hdNode;
    }

    static public HashMap createHashMapWithHDNode(HDNode hdNode) {
        if (hdNode == null) {
            return null;
        }
        @SuppressWarnings("unchecked")
        HashMap<String, Object> map = new HashMap();
        map.put("depth", hdNode.depth);
        map.put("childNum", hdNode.childNum);
        map.put("chainCode", hdNode.chainCode);
        map.put("publicKey", hdNode.pubKey);
        if (hdNode.fingerPrint != 0) {
            map.put("fingerprint", hdNode.fingerPrint);
        }
        return map;
    }

    static public byte[] secureRandom(int len) {
        byte bytes[] = new byte[len];
        SecureRandom random = new SecureRandom();
        random.nextBytes(bytes);
        return  bytes;
    }

    static public void cryptoMethodCallHandler(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "generateEcdsaKeypair": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                Number compress = (Number) args.get("compress");
                byte[] privateKey = secureRandom(32);
                byte[] pubKey = JNICryptoUtils.getEcdsaPubKey(privateKey, compress.intValue());
                @SuppressWarnings("unchecked")
                List<String> items = new ArrayList();
                String privateHexKey = CommonUtils.bytesToHex(privateKey).toLowerCase();
                String pubHexKey = CommonUtils.bytesToHex(pubKey).toLowerCase();
                items.add(pubHexKey);
                items.add(privateHexKey);
                ClearUtil.clearBytes(privateKey);
                ClearUtil.clearBytes(pubKey);
                result.success(items);
            }
            break;
            case "base58Encode": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args =  (Map<String, Object>)call.arguments;
                byte[] data = (byte[]) args.get("data");
                String bash58Hasher = (String) args.get("base58Hasher");
                String base58Result = JNICryptoUtils.base58Encode(data, bash58Hasher);
                result.success(base58Result);
            }
            break;
            case "generateCryptoKey": {
                @SuppressWarnings("unchecked")
                Map<String, byte[]> args = (Map<String, byte[]>) call.arguments;
                byte[] prvData = args.get("private_key");
                byte[] pubData = args.get("pub_key");
                byte[] results = JNICryptoUtils.getAesKey(pubData, prvData);
                result.success(results);
                ClearUtil.clearBytes(prvData);
                ClearUtil.clearBytes(pubData);
            }
            break;
            case "sha256": {
                @SuppressWarnings("unchecked")
                byte[] data = (byte[]) call.arguments;
                byte[] sha256Result = JNICryptoUtils.sha256(data);
                result.success(sha256Result);
            }
            break;
            case "base58Decode": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                String address = (String) args.get("address");
                String hasher = (String)args.get("base58Hasher");
                Number len = (Number) args.get("len");
                int desLen = 0;
                if (len != null) {
                    desLen = len.intValue();
                }
                byte[] datas = JNICryptoUtils.base58Decode(address, hasher, 0, desLen);
                result.success(datas);
            }
            break;
            case "generateBech32Address": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                @SuppressWarnings("unchecked")
                Map<String, Object> nodesJson = (Map<String, Object>) args.get("node");
                Number depth = (Number) nodesJson.get("depth");
                byte[] pubKey = (byte[]) nodesJson.get("publicKey");
                byte[] chainCode = (byte[]) nodesJson.get("chainCode");
                Number childNum = (Number) nodesJson.get("childNum");
                Number singleKey = (Number)nodesJson.get("singleKey");
                Number fingerprint = (Number) nodesJson.get("fingerprint");
                Number index = (Number) args.get("index");
                Number version = (Number) args.get("version");
                Number change = (Number) args.get("change");
                String curve = (String) args.get("curve");
                String hrp = (String) args.get("hrp");
                String address = JNICryptoUtils.getHDNodeSegwitAddress(
                        depth.intValue(),
                        childNum.intValue(),
                        fingerprint.intValue(),
                        chainCode,
                        pubKey,
                        change.intValue(),
                        index.intValue(),
                        version.intValue(),
                        curve,
                        hrp,
                        singleKey.intValue());
                result.success(address);
            }
            break;
            case "getHDNodeXpub": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                @SuppressWarnings("unchecked")
                Map<String, Object> nodesJson = (Map<String, Object>) args.get("node");
                Number depth = (Number) nodesJson.get("depth");
                byte[] pubKey = (byte[]) nodesJson.get("publicKey");
                byte[] chainCode = (byte[]) nodesJson.get("chainCode");
                Number childNum = (Number) nodesJson.get("childNum");
                Number fingerprint = (Number) nodesJson.get("fingerprint");
                String curve = (String) args.get("curve");
                Number magicVersion = (Number)args.get("version");
                String xpub = JNICryptoUtils.getHDNodeXpub(
                        depth.intValue(),
                        childNum.intValue(),
                        fingerprint.intValue(),
                        chainCode,
                        pubKey,
                        curve,
                        magicVersion.intValue()
                );
                result.success(xpub);
            }
            break;
            case "generateBitcoinAddress": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                @SuppressWarnings("unchecked")
                Map<String, Object> nodesJson = (Map<String, Object>) args.get("node");
                Number depth = (Number) nodesJson.get("depth");
                byte[] pubKey = (byte[]) nodesJson.get("publicKey");
                byte[] chainCode = (byte[]) nodesJson.get("chainCode");
                Number childNum = (Number) nodesJson.get("childNum");
                Number singleKey = (Number)nodesJson.get("singleKey");
                String curve = (String) args.get("curve");
                Number prefix = (Number)args.get("prefix");
                Number changeIndex = (Number)args.get("changeIndex");
                Number index = (Number)args.get("index");
                Number purpose = (Number)args.get("purpose");
                String address = JNICryptoUtils.getHDNodeBitcoinAddress(
                        depth.intValue(),
                        childNum.intValue(),
                        chainCode,
                        pubKey,
                        curve,
                        prefix.intValue(),
                        changeIndex.intValue(),
                        index.intValue(),
                        0,
                        purpose.intValue(),
                        singleKey.intValue()
                );
                result.success(address);
            }
            break;
            case "checkEthAddress": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                String address = (String) args.get("address");
                result.success(JNICryptoUtils.checkEthAddress(address));
            }
            break;
            case "aes256CFBEncrypt": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                byte[] data = (byte[]) args.get("data");
                byte[] key = (byte[]) args.get("key");
                result.success(JNICryptoUtils.aes256CFBEncrypt(data, key));
                ClearUtil.clearBytes(key);
            }
            break;
            case "aes256CFBDecrypt": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                byte[] data = (byte[]) args.get("data");
                byte[] key = (byte[]) args.get("key");
                result.success(JNICryptoUtils.aes256CFBDecrypt(data, key));
                ClearUtil.clearBytes(key);
            }
            break;
            case "getChildHDNode": {
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                @SuppressWarnings("unchecked")
                Map<String, Object> nodesJson = (Map<String, Object>) args.get("node");
                HDNode hdNode = toHDNodeFromMap(nodesJson);
                @SuppressWarnings("unchecked")
                String curve = (String) args.get("curve");
                Number childIndex = (Number)args.get("childIndex");
                HDNode childNode = JNICryptoUtils.getChildNode(hdNode, curve, childIndex.intValue());
                result.success(createHashMapWithHDNode(childNode));
            }
            break;
            case "getEthAddressForNode":{
                @SuppressWarnings("unchecked")
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                @SuppressWarnings("unchecked")
                Map<String, Object> nodesJson = (Map<String, Object>) args.get("node");
                Number depth = (Number) nodesJson.get("depth");
                byte[] pubKey = (byte[]) nodesJson.get("publicKey");
                byte[] chainCode = (byte[]) nodesJson.get("chainCode");
                Number childNum = (Number) nodesJson.get("childNum");
                String address = JNICryptoUtils.getEthAddressForNode(depth.intValue(), childNum.intValue(), chainCode, pubKey);
                result.success(address);
            }
            default: {
                if (result != null) {
                    result.notImplemented();
                }
            }
            break;
        }
    }
}
