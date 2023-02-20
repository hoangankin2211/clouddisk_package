import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'language_supported.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  final Map<String, String> _localizeValue = {};

  Future<void> load() async {
    String jsonStringValue =
        await rootBundle.loadString("lib/lang/${locale.languageCode}.json");
    Map<String, dynamic> mapJson = json.decode(jsonStringValue);

    _localizeValue
        .addAll(mapJson.map((key, value) => MapEntry(key, value.toString())));
  }

  String translate(String key) {
    return _localizeValue[key] ?? "key";
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return LanguageSupported.languageSupported.contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization appLocalization = AppLocalization(locale);
    await appLocalization.load();
    return appLocalization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}
