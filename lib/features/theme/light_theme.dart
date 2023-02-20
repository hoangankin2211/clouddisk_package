import 'package:flutter/material.dart';

class MyCustomLightTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: MyLightColorScheme.colorScheme.brightness,
    primaryColor: MyLightColorScheme.colorScheme.primary,
    scaffoldBackgroundColor: MyLightColorScheme.colorScheme.background,
    colorScheme: MyLightColorScheme.colorScheme,
    appBarTheme: MyCustomAppBarTheme.lightThemeAppbar,
    textTheme: MyCustomTextTheme.lightThemeText,
  );
}

class MyCustomTextTheme {
  static const lightThemeText = TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 13,
    ),
  );
}

class MyLightColorScheme {
  static final colorScheme = ColorScheme(
    primary: Colors.blue,
    secondary: Colors.green,
    surface: Colors.white,
    background: Colors.grey.shade100,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.grey.shade900,
    onBackground: Colors.grey.shade900,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}

class MyCustomAppBarTheme {
  static final lightThemeAppbar = AppBarTheme(
    color: MyLightColorScheme.colorScheme.primary,
    iconTheme: IconThemeData(color: MyLightColorScheme.colorScheme.onPrimary),
    titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}
