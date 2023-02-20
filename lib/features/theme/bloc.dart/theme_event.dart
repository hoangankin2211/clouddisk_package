part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final BuildContext context;

  ChangeThemeEvent(this.context);
}
