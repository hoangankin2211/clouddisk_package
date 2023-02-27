import 'package:flutter/material.dart';

class RootPath {
  static String? root = "/";
  static String? languageCode = "en";
  static String? hmail_key = "";
  static String? session = "";
  static ThemeMode? themeMode = ThemeMode.system;
  static void setRoot({
    String? root,
    String? languageCode,
    String? hmail_key,
    String? session,
    ThemeMode? themeMode,
  }) {
    RootPath.root = root;
    RootPath.languageCode = languageCode;
    RootPath.hmail_key = hmail_key;
    RootPath.session = session;
    RootPath.themeMode = themeMode;
  }
}
