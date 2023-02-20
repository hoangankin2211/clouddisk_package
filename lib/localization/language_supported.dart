import 'package:clouddisk/utils/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'app_localization.dart';

class LanguageSupported {
  static const defaultLocale = Locale("en", "EN");
  static const List<String> languageSupported = ["en", "ko", "vi"];

  Future<Locale> saveLocale(String languageCode) async {
    await SharedPreferencesUtils.sharedPreferences!
        .setString("locale", languageCode);
    return getLocale(languageCode);
  }

  static Locale getLocale(String languageCode) {
    switch (languageCode) {
      case "en":
        return const Locale("en", "EN");
      case "ko":
        return const Locale("ko", "KO");
      case "vi":
        return const Locale("vi", "VN");
      default:
        return const Locale("en", "EN");
    }
  }

  String translate(BuildContext context, String key) {
    return AppLocalization.of(context)?.translate(key) ?? "";
  }
}
