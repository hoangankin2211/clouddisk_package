part of 'theme_bloc.dart';

class ThemeState {
  final ThemeMode mode;

  ThemeState._({required this.mode});

  ThemeState.init({required ThemeMode mode}) : this._(mode: mode);

  ThemeState.newTheme({required this.mode});
}
