import 'package:flutter/material.dart';

class MyCustomDarkTheme {
  static final darkTheme = ThemeData(
    brightness: MyDarkColorScheme.darkColorScheme.brightness,
    primaryColor: MyDarkColorScheme.darkColorScheme.primary,
    scaffoldBackgroundColor: MyDarkColorScheme.darkColorScheme.background,
    appBarTheme: MyCustomAppBarTheme.darkThemeAppbar,
    textTheme: MyCustomTextTheme.darkThemeText,
    colorScheme: MyDarkColorScheme.darkColorScheme
        .copyWith(secondary: MyDarkColorScheme.darkColorScheme.secondary),
  );
}

class MyCustomTextTheme {
  static const darkThemeText = TextTheme(
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

class MyDarkColorScheme {
  static final ColorScheme darkColorScheme = ColorScheme(
    primary: Colors.orange,
    secondary: Colors.purple,
    surface: Colors.grey.shade900,
    background: Colors.grey.shade800,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  );
}

class MyCustomAppBarTheme {
  static final darkThemeAppbar = AppBarTheme(
    color: MyDarkColorScheme.darkColorScheme.primary,
    iconTheme:
        IconThemeData(color: MyDarkColorScheme.darkColorScheme.onSurface),
    titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}
