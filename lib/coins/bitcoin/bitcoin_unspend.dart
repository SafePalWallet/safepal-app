import 'package:json_annotation/json_annotation.dart';

import '../hd_derived_path.dart';

part 'bitcoin_unspend.g.dart';

@JsonSerializable()
class BitcoinUnspend {
  String? txid;

  @JsonKey(name: 'vout')
  int? txIndex;

  @JsonKey(name: 'value')
  String? amount;

  int? confirmations;
  int? lockTime;
  String? address;
  String? path;
  int? coinbase;

  int get index {
    HDDerivedPath derivedPath = HDDerivedPath.derivedPathWithPath(this.path)!;
    int? idx = derivedPath.index;
    return idx ?? 0;
  }

  bool? get isReceive {
    HDDerivedPath derivedPath = HDDerivedPath.derivedPathWithPath(this.path)!;
    return derivedPath.change;
  }

  BigInt? _amountVal;

  BigInt? get amountVal {
//    Debug.v('amount:${this.amount}');
    if (_amountVal == null) {
      _amountVal = BigInt.tryParse(this.amount!, radix: 10);
    }
    return _amountVal;
  }

  BitcoinUnspend({
    this.txid,
    this.txIndex,
    this.amount,
    this.confirmations,
    this.lockTime,

    this.address,
    this.path,
    this.coinbase
  });



  factory BitcoinUnspend.fromJson(Map<String, dynamic> json) => _$BitcoinUnspendFromJson(json);
  Map<String, dynamic> toJson() => _$BitcoinUnspendToJson(this);

}