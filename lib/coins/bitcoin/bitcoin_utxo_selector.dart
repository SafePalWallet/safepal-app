import '../hd_purpose_util.dart';
import 'bitcoin_unspend.dart';

class BitcoinUtxoFeeCalculator {
  static const  double gDefaultBytesPerInput = 148;
  static const  double gDefaultBytesPerOutput = 34;
  static const  double gDefaultBytesBase = 10;
  static const  double gSegwitBytesPerInput = 101.25;
  static const  double gSegwitBytesPerOutput = 31;
  static const  double gSegwitBytesBase = gDefaultBytesBase;

  static const  double gDecredBytesPerInput = 166;
  static const  double gDecredBytesPerOutput = 38;
  static const  double gDecredBytesBase = 12;

  final BIPPurposeType purpose;

  BitcoinUtxoFeeCalculator({
    required this.purpose
  });

  BigInt singleInputFee(BigInt bytefee) {
    if (this.purpose == BIPPurposeType.bip44) {
      return BigInt.from(gDefaultBytesPerInput.ceil()) * bytefee;
    } else {
      final int value = gSegwitBytesPerInput.ceil();
      return BigInt.from(value) * bytefee;
    }
  }

  BigInt calFee({int? numInput, int? numOutput, BigInt? bytefee}) {
    late int txSize;
    if (this.purpose == BIPPurposeType.bip44) {
      txSize = ((gDefaultBytesPerInput.ceil() * numInput!) + (gDefaultBytesPerOutput.ceil() * numOutput!) + gDefaultBytesBase).toInt();
    } else {
      txSize = ((gSegwitBytesPerInput.ceil() * numInput!) + (gSegwitBytesPerOutput.ceil() * numOutput!) + gSegwitBytesBase).toInt();
    }
    return BigInt.from(txSize) * bytefee!;
    }
}

class BitcoinUtxoSelector {

  static BigInt dustThreshold = BigInt.from(3 * 182);

  final BIPPurposeType purpose;
  final BigInt dust;
  final List<BitcoinUnspend> utxos;
  final BigInt bytefee;
  final BigInt targetVal;
  final int numOutput;

  late BitcoinUtxoFeeCalculator _calculator;

  BitcoinUtxoSelector({
    required this.purpose,
    required this.utxos,
    required this.bytefee,
    required this.targetVal,
    required this.numOutput,
    required this.dust,
  }) {
    _calculator = BitcoinUtxoFeeCalculator(purpose: this.purpose);
  }

  static List<List<BitcoinUnspend>>? slice({List<BitcoinUnspend>? utxos, int numSlice = 1}) {
    if (utxos == null || utxos.isEmpty) {
      return null;
    }

    List<List<BitcoinUnspend>> results = [];
    for (int index = 0; index <= utxos.length - numSlice; index++) {
      final List<BitcoinUnspend> item = utxos.sublist(index, index + numSlice);
      results.add(item);
    }
    return results;
  }

  static BigInt sumAmount(List<BitcoinUnspend> utxos) {
    if (utxos == null || utxos.isEmpty) {
      return BigInt.zero;
    }
    BigInt result = BigInt.zero;
    for (BitcoinUnspend item in utxos) {
      result += item.amountVal!;
    }
    return result;
  }

  static List<BitcoinUnspend>? sort({List<BitcoinUnspend>? utxos}) {
    if (utxos == null || utxos.isEmpty) {
      return utxos;
    }
    utxos.sort((obj1, obj2){
      return obj1.amountVal!.compareTo(obj2.amountVal!);
    });
    return utxos;
  }


  List<BitcoinUnspend> filterDustInput(List<BitcoinUnspend> items) {
    List<BitcoinUnspend> results = [];
    BigInt singleInputFee = _calculator.singleInputFee(this.bytefee);
    for (BitcoinUnspend item in items) {
      if (item.amountVal! > singleInputFee) {
        results.add(item);
      }
    }
    return results;
  }

  List<BitcoinUnspend> select() {
    if (this.targetVal <= BigInt.zero) {
      return [];
    }
    if (this.utxos.isEmpty) {
      return [];
    }
    BigInt sum = sumAmount(this.utxos);
    if (sum < this.targetVal) {
      return [];
    }

    BigInt doubleTargetValue = this.targetVal * BigInt.two;
    List<BitcoinUnspend> sortedUtxos = sort(utxos:this.utxos)!;

    var distFrom2x = (BigInt val){
      if (val > doubleTargetValue) {
        return val - doubleTargetValue;
      } else {
        return doubleTargetValue - val;
      }
    };

    int numOuput = this.numOutput;
    // 1. Find a combination of the fewest outputs that is
    //    (1) bigger than what we need
    //    (2) closer to 2x the amount,
    //    (3) and does not produce dust change.
    int numInput = 1;
    for (;numInput <= sortedUtxos.length; numInput += 1) {
      BigInt  fee = _calculator.calFee(numInput: numInput, numOutput: numOuput, bytefee: this.bytefee);
      BigInt targetWithFeeAndDust = this.targetVal + fee + this.dust;
      List<List<BitcoinUnspend>> slices = slice(utxos: sortedUtxos, numSlice: numInput)!;
      slices.removeWhere((List<BitcoinUnspend> item){
        return sumAmount(item) < targetWithFeeAndDust;
      });

      if (slices.isNotEmpty) {
        slices.sort((obj1, obj2){
          BigInt dist1 = distFrom2x(sumAmount(obj1));
          BigInt dist2 = distFrom2x(sumAmount(obj2));
          return dist1.compareTo(dist2);
        });
        List<BitcoinUnspend> result = filterDustInput(slices.first);
        return result;
      }
    }

    // 2. If not, find a combination of outputs that may produce dust change.
    numOuput = 1;
    for ( numInput = 1; numInput <= sortedUtxos.length; numInput += 1) {
      BigInt  fee = _calculator.calFee(numInput: numInput, numOutput: numOuput, bytefee: this.bytefee);
      BigInt targetWithFee = this.targetVal + fee;
      List<List<BitcoinUnspend>> slices = slice(utxos: sortedUtxos, numSlice: numInput)!;
      slices.removeWhere((List<BitcoinUnspend> item){
        return sumAmount(item) < targetWithFee;
      });
      if (!slices.isEmpty) {
        return filterDustInput(slices.first);
      }
    }

    return [];
  }


}