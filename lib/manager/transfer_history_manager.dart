
import 'dart:convert';

import 'package:safepal_example/model/transfer_history.dart';
import 'package:safepal_example/utils/time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferHistoryManager {
  final String _bitcoinKey = "bitcoin_history_key";
  final String _ethereumKey = "etherum_history_key";

  List<TransferHistory> _bitcoinHisotys = [];
  List<TransferHistory> _ethereumHisotys = [];

  Future<void> loadData() async {
    _bitcoinHisotys = await _getHisotry(key: _bitcoinKey);
    _ethereumHisotys = await _getHisotry(key: _ethereumKey);
  }

  Future<List<TransferHistory>> _getHisotry({required String key}) async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    final String? value = prefs.getString(key);
    if (value == null || value.isEmpty) {
      return [];
    }
    final dynamic objects = json.decode(value);
    if (objects is! List) {
      return [];
    }
    final List<TransferHistory> results = [];
    for (dynamic item in objects) {
      final TransferHistory? history = TransferHistory.tryParse(item);
      if (history == null) {
        continue;
      }
      results.add(history);
    }
    return results;
  }

  Future<void> addHistory({required TransferHistory history, required bool isBitcoin}) async {
    late List<TransferHistory> results;
    late String key;
    if (isBitcoin) {
      key = _bitcoinKey;
      results = _bitcoinHisotys;
    } else {
      key = _ethereumKey;
      results = _ethereumHisotys;
    }
    if (results.contains(history)) {
      return;
    }

    results.isEmpty ? results.add(history) : results.insert(0, history);
    final List<dynamic> data = [];
    for (TransferHistory item in results) {
      data.add(item.toJson());
    }
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, json.encode(data));
  }

  List<TransferHistory> historys({required bool isBitcoin}) {
    return [
    ];

    return isBitcoin ? _bitcoinHisotys : _ethereumHisotys;
  }

}