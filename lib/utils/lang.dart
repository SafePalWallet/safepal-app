import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'debug_logger.dart';

enum LangType {
  en,
  zh,
  zht,
  de,
  fr,
  es,
  it,
  ko,
  ja,
  vi,
  pt,
  ru,
  th,
  id,
  tr
}

class Lang {
  final LangType? type;
  final Locale? locale;
  final String? des;

  Lang({
    this.type,
    this.des,
    this.locale
  });

  String get intlCode {
    if (this.locale == null) {
      return "en";
    } else if (this.locale?.countryCode == null || this.locale!.countryCode!.isEmpty) {
      return "${this.locale?.languageCode}";
    }
    return "${this.locale?.languageCode}-${this.locale?.countryCode}";
  }
}

LangConfig langConfig = LangConfig();

class LangConfig {
  static const LangSaveKey = 'io.safepal.LangSaveKey';
  static const  defaultLangType = LangType.en;
  static final LangConfig _config_ =  LangConfig._internal();

  LangType? systemLang;

  Locale? _rawSystemLocale;

  Lang? _lang;

  static const defaultLocale = Locale('en', 'US');

  factory LangConfig(){
    return _config_;
  }
  LangConfig._internal() {
    loadSystemLang();
  }

  Future<void> loadSystemLang() async {
    Locale? locale = ui.window.locale;;
    _rawSystemLocale = locale;
    this.systemLang = langTypeFromLocale(locale, allowNull: true);
  }

  Locale? get rawSystemLocale {
    return _rawSystemLocale;
  }

  List<Lang> supportedLangs() {
    return [
      Lang(type: LangType.en, des: 'English', locale: Locale('en')),
      Lang(type: LangType.ru, des: 'Pусский', locale: Locale('ru')),
      Lang(type: LangType.ja, des: '日本語', locale: Locale('ja')),
      Lang(type: LangType.ko, des: '한국어', locale: Locale('ko')),
      Lang(type: LangType.de, des: 'Deutsch', locale: Locale('de')),
      Lang(type: LangType.es, des: 'Español', locale: Locale('es')),
      Lang(type: LangType.fr, des: 'Français', locale: Locale('fr')),
      Lang(type: LangType.pt, des: 'Português', locale: Locale('pt')),
      Lang(type: LangType.it, des: 'Italiano', locale: Locale('it')),
      Lang(type: LangType.tr, des: 'Türkçe', locale: Locale('tr')),
      Lang(type: LangType.th, des: 'ภาษาไทย', locale: Locale('th')),
      Lang(type: LangType.vi, des: 'Tiếng việt', locale: Locale('vi')),
      Lang(type: LangType.id, des: 'Bahasa Indonesia', locale: Locale('id')),
      Lang(type: LangType.zht, des: '繁體中文', locale: Locale('zh', 'HK')),
      Lang(type: LangType.zh, des: '简体中文', locale: Locale('zh')),
    ];
  }

  static Map<LangType, String> todayLabels = {
    LangType.en: 'Today',
    LangType.zh: '今天',
    LangType.zht: '今天',
    LangType.ko : '오늘',
    LangType.ja : 'きょう',
    LangType.de : 'Heute',
    LangType.fr : 'Aujourd\'hui',
    LangType.es : 'Hoy',
    LangType.it : 'oggi',
    LangType.vi : 'Hôm nay',
    LangType.ru : 'Cегодня',
    LangType.th : 'Today',
    LangType.id : 'Today',
    LangType.tr : 'Today',
  };

  static Map<LangType, String> hourLabels = {
    LangType.en: 'H',
    LangType.zh: '时',
    LangType.zht: '时',
    LangType.ko : '시간',
    LangType.ja : '時間',
    LangType.de : 'h',
    LangType.fr : 'h',
    LangType.es : 'h',
    LangType.it : 'h',
    LangType.vi : 'g',
    LangType.pt : 'h',
    LangType.ru : 'h',
    LangType.th : 'h',
    LangType.id : 'h',
    LangType.tr : 'h',
  };

  static Map<LangType, String> minLabels = {
    LangType.en: 'min',
    LangType.zh: '分',
    LangType.zht: '分',
    LangType.ko: '분',
    LangType.ja: '分',
    LangType.de: 'min',
    LangType.fr: 'mn',
    LangType.es: 'min',
    LangType.it: 'min',
    LangType.vi: 'ph',
    LangType.pt: 'min',
    LangType.ru: 'min',
    LangType.th : 'min',
    LangType.id : 'min',
    LangType.tr : 'min',
  };

  static Map<LangType, String> secondLabels = {
    LangType.en: 's',
    LangType.zh: '秒',
    LangType.zht: '秒',
    LangType.ko : '둘째',
    LangType.ja : '第二',
    LangType.de : 's',
    LangType.fr : 'Deuxième',
    LangType.es : 'Segundo',
    LangType.it : 's',
    LangType.vi : 'th',
    LangType.pt : 's',
    LangType.ru: 's',
    LangType.th : 's',
    LangType.id : 's',
    LangType.tr : 's',
  };

  List<Locale> supportedLocales() {
    List<Locale> locales = [];
    for (Lang item in supportedLangs()) {
      locales.add(item.locale!);
    }
    return locales;
  }

  LangType? langTypeFromLocale(Locale? locale, {bool allowNull = false}) {
    if (locale == null) {
      if (allowNull) {
        return null;
      }
      return LangType.en;
    }
    switch (locale.languageCode) {
      case 'en':
        return LangType.en;
        break;
      case 'zh': {
        const List<String> zhtCodes = ['TW', 'HK', 'MO'];
        if (locale.countryCode != null && zhtCodes.contains(locale.countryCode)) {
          return LangType.zht;
        }
        return LangType.zh;
      }
        break;
      case 'de':
        return LangType.de;
        break;
      case 'es':
        return LangType.es;
        break;
      case 'it':
        return LangType.it;
        break;
      case 'ko':
        return LangType.ko;
        break;
      case 'ja':
        return LangType.ja;
        break;
      case 'vi':
        return LangType.vi;
        break;
      case 'fr':
        return LangType.fr;
        break;
      case 'pt':
        return LangType.pt;
        break;
      case 'ru':
        return LangType.ru;
        break;
      case 'th':
        return LangType.th;
      case 'id':
        return LangType.id;
      case 'tr':
        return LangType.tr;
        break;
    }
    if (allowNull) {
      return null;
    }
    return LangType.en;
  }

  Lang? _findLangWithType(LangType type) {
    for (Lang item in this.supportedLangs()) {
      if (item.type == type) {
        return item;
      }
    }
    return null;
  }

  Future<Lang?> asyncGetCurLang() async {
    if (_lang != null) {
      return _lang;
    }
    final int type = LangType.en.index;

    for (Lang item in this.supportedLangs()) {
      if (item.type!.index == type) {
        _lang = item;
        break;
      }
    }
    if (_lang == null) {
      _lang = _findLangWithType(LangType.en);
    }
    return _lang;
  }

  Lang? get curLang {
    return _lang;
  }

}