
enum BIPPurposeType {
  bip44,
  bip49,
  bip84
}

class HDPurposeUtil {

  static BIPPurposeType? getPurposeTypeForDerivedValue(int derivedPurpose) {
    if (derivedPurpose == 44) {
      return BIPPurposeType.bip44;
    } else if (derivedPurpose == 49) {
      return BIPPurposeType.bip49;
    } else if (derivedPurpose == 84) {
      return BIPPurposeType.bip84;
    }
    return null;
  }

  static int? getDerivedValueForPurposeType(BIPPurposeType type) {
    switch (type) {
      case BIPPurposeType.bip44:
        return 44;
      case BIPPurposeType.bip49:
        return 49;
      case BIPPurposeType.bip84:
        return 84;
      default:
        return null;
    }
  }
}