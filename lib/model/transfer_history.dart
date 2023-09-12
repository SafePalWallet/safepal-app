
class TransferHistory {

  final String amount;
  final int timestamp;
  final String txid;
  final String to;

  TransferHistory({
    required this.amount,
    required this.timestamp,
    required this.txid,
    required this.to
  });

  Map<String, dynamic> toJson() {
    return {
      "amount" : this.amount,
      "timestamp" : this.timestamp,
      "txid" : this.txid,
      "to" : this.to
    };
  }

  static TransferHistory? tryParse(dynamic data) {
    if (data is! Map) {
      return null;
    }
    if (data['txid'] == null) {
      return null;
    }
    return TransferHistory(
        amount: data['amount'],
        timestamp: data['timestamp'],
        txid: data['txid'],
        to: data['to']
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final TransferHistory object = other as TransferHistory;
    return object.txid == this.txid;
  }

  @override
  int get hashCode => this.txid.hashCode;

}