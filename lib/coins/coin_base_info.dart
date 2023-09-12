import 'package:json_annotation/json_annotation.dart';
import '../utils/coin_utils.dart';

part 'coin_base_info.g.dart';

@JsonSerializable()
class CoinBaseInfo  {
  final int type;
  final String uname;
  String? path;

  CoinBaseInfo({
    required this.type,
    required this.uname,
    this.path,
  });

  factory CoinBaseInfo.fromJson(Map<String, dynamic> json) => _$CoinBaseInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CoinBaseInfoToJson(this);

  static CoinBaseInfo? fromTid(String? id) {
    if (id == null || id.isEmpty) {
      return null;
    }
    List<String> items = id.split(":");
    if (items.length < 2) {
      return null;
    }
    int? type = int.tryParse(items[0]);
    if (type == null) {
      return null;
    }
    return CoinBaseInfo(type: type, uname: items[1]);
  }

  String? _tId;
  String? get tId {
    if (_tId != null) {
      return _tId;
    }
    _tId = "$type:$uname";
    return _tId;
  }

  int get hashCode {
    return this.type.hashCode ^ this.uname.hashCode;
  }

  bool operator ==(Object other) {
    if (other is CoinBaseInfo) {
      return other.type == this.type &&
          other.uname == this.uname;
    }
    return false;
  }

  CoinCategory get coinCatetory {
    for (CoinCategory item in CoinCategory.values) {
      if (item.index == this.type) {
        return item;
      }
    }
    return CoinCategory.unkown;
  }

  String? get symbol {
    return this.uname;
  }

}