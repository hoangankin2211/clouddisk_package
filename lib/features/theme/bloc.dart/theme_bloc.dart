import 'package:clouddisk/clouddisk.dart';
import 'package:clouddisk/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({required ThemeMode mode}) : super(ThemeState.init(mode: mode)) {
    on<ChangeThemeEvent>(handleChangeThemeEvent);
  }

  void handleChangeThemeEvent(
      ChangeThemeEvent event, Emitter<ThemeState> emit) {
    ThemeMode result;
    if (state.mode == ThemeMode.system) {
      event.context.isDarkMode
          ? result = ThemeMode.light
          : result = ThemeMode.dark;
    }
    if (state.mode == ThemeMode.dark) {
      result = ThemeMode.light;
    } else {
      result = ThemeMode.dark;
    }

    emit(ThemeState.newTheme(mode: result));
  }
}
