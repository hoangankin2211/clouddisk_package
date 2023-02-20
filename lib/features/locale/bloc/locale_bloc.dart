import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../localization/language_supported.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc({required String languageCode})
      : super(LocaleState.init(languageCode: languageCode)) {
    on<ChangedLocaleEvent>(handleChangeLocaleEvent);
  }

  void handleChangeLocaleEvent(
      ChangedLocaleEvent event, Emitter<LocaleState> emit) {
    if (event.newLocale.languageCode == state.locale.languageCode) {
      return;
    }
    emit(LocaleState.changeLocale(locale: event.newLocale));
  }
}
