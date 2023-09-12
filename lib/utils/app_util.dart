import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'crypto_plugin.dart';

final AppUtil appUtil =  AppUtil();

class AppUtil {
  static const String _cachedAppPublickKey = 'cache.app.public.key';
  static const String _cacheAppPrivateKey = 'cache.app.private.key';

  Future<String> clientUId() async {
    final key = "example.client.uid.key";
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? uid = await pref.getString(key);
    if (uid != null) {
      return uid;
    }

    List<int> list = [];
    final Random random = Random.secure();
    for (int index = 0; index < 8; index++) {
      list.add(random.nextInt(1<<32));
    }
    var digest = sha256.convert(list);
    String result = (await CryptoPlugin.base58Encode(Uint8List.fromList(digest.bytes)))!;

    if (result.length > 20) {
      result = result.substring(result.length - 20);
    }
    await pref.setString(key, result);
    return result;
  }

  Future<String> phoneModel() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final LocalPlatform platform = LocalPlatform();
    if (platform.isAndroid) {
      final AndroidDeviceInfo ad = await deviceInfoPlugin.androidInfo;
      return '${ad.manufacturer}-${ad.brand}-${ad.board}';
    } else if (platform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.utsname.machine;
    }
    return '';
  }

  Future<bool> hasClientKey() async {
    String? pubKey = await getClientPubKey();
    String? priKey = await getClientPrivateKey();
    if (pubKey == null || priKey == null) {
      return false;
    }
    return true;
  }

  Future<String?> getClientPubKey() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(_cachedAppPublickKey);
  }

  Future<String?> getClientPrivateKey() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(_cacheAppPrivateKey);
  }

  Future<void> updateClientKey({required String pubkey, required String privkey}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(_cachedAppPublickKey, pubkey);
    await pref.setString(_cacheAppPrivateKey, privkey);
  }

}