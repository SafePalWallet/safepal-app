
import 'package:safepal_example/coins/coin.dart';

class HDMagicVersion {
  static const int None = 0;

  // Bitcoin
  static const int XPUB = 0x0488b21e;
  static const int XPRV = 0x0488ade4;
  static const int YPUB = 0x049d7cb2;
  static const int YPRV = 0x049d7878;
  static const int ZPUB = 0x04b24746;
  static const int ZPRV = 0x04b2430c;

  static const int TPUB = 0x043587CF;

  // Litecoin
  static const int LTUB = 0x019da462;
  static const int LTPV = 0x019d9cfe;
  static const int MTUB = 0x01b26ef6;
  static const int MTPV = 0x01b26792;

  // Decred
  static const int DPUB = 0x2fda926;
  static const int DPRV = 0x2fda4e8;

  // Dogecoin
  static const int DGUB = 0x02facafd;
  static const int DGPV = 0x02fac398;


  static bool isPublicKeyVersion(int version) {
    switch (version) {
      case XPUB:
      case YPUB:
      case ZPUB:
      case LTUB:
      case MTUB:
      case DPUB:
      case DGUB:
        return true;

      case XPRV:
      case YPRV:
      case ZPRV:
      case LTPV:
      case MTPV:
      case DPRV:
      case DGPV:
        return false;

      default:
        return false;
    }
  }

  static bool isPrivateKeyVersion(int version) {
    if (version == None) {
      return false;
    }
    if (!isPublicKeyVersion(version)) {
      return true;
    }
    return false;
  }

  static Map<String, dynamic> extendedPublicKeyMagicVersions = {
    'xpub' : XPUB,
    'ypub' : YPUB,
    'zpub' : ZPUB,
    'ltub' : LTUB,
    'mtub' : MTUB,
    'dpub' : DPUB,
    'dgub' : DGUB
  };

  static Map<String, dynamic> extendedPrivateKeyMagicVersions = {
    'xprv' : XPRV,
    'yprv' : YPRV,
    'zprv' : ZPRV,
    'ltpv' : LTPV,
    'mtpv' : MTPV,
    'dprv' : DPRV,
    'dgpv' : DGPV
  };

  static int? getExtendedMagicVersionFor({required String name}) {
    if (name.isEmpty) {
      return null;
    }
    int? result = extendedPublicKeyMagicVersions[name];
    if (result != null) {
      return result;
    }
    result = extendedPrivateKeyMagicVersions[name];
    return result;
  }

}