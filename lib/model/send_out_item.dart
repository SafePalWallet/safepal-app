
class SendOutItem {
  String? address;
  String? amountText;
  BigInt? amount = BigInt.zero;

  @override
  String toString() {
    return 'address:$address amountText:$amountText amount:${amount?.toRadixString(10)}';
  }
}