import 'package:flutter/material.dart';

class HDDerivedPath {
  int? purpose;
  int? coin;
  int? account;

  bool? change;
  int? index;

  // m/84'/2'/0'/0/0
  String? path;


  // m/84'/2'/0
  String get prefix {
    return "m/$purpose'/$coin'/$account'";
  }

  String get suffixPath {
    return '${this.change! ? 1 : 0}/${this.index}';
  }

  static HDDerivedPath? derivedPathWithPath(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }
    HDDerivedPath derivedPath = HDDerivedPath();
    derivedPath.path = path;

    // m/84'/2'/0'/0/3
    path = path.toLowerCase();
    path = path.replaceAll("'", '');
    path = path.replaceAll("h", '');
    path = path.replaceAll("m/", '');

    List<String> items = path.split('/');
    if (items.length < 3) {
      return null;
    }
    derivedPath.purpose = int.tryParse(items[0]);
    derivedPath.coin = int.tryParse(items[1]);

    if (items.length >= 3) {
      derivedPath.account = int.tryParse(items[2]);
    }
    if (items.length >= 4) {
      derivedPath.change = int.tryParse(items[3]) == 0 ? false : true;
    }
    if (items.length >= 5) {
      derivedPath.index = int.tryParse(items[4]) ?? 0;
    }

    derivedPath.account = derivedPath.account ?? 0;
    derivedPath.change = derivedPath.change ?? false;
    derivedPath.index = derivedPath.index ?? 0;

    return derivedPath;
  }

  static HDDerivedPath derivedPath({int purpose = 44, int coin = 0, int account = 0, bool change = false, int index = 0}) {
    HDDerivedPath derivedPath = HDDerivedPath();
    derivedPath.purpose = purpose;
    derivedPath.coin = coin;
    derivedPath.account = account;
    derivedPath.change = change;
    derivedPath.index = index;
    derivedPath.path = 'm/${purpose}\'/${coin}\'${account}\'/${change ? 1 : 0}/${index}';
    return derivedPath;
  }

}