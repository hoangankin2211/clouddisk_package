part of "locale_bloc.dart";

class LocaleState {
  late final Locale locale;

  LocaleState({required String languageCode}) {
    locale = LanguageSupported.getLocale(languageCode);
  }

  LocaleState.init({required String languageCode})
      : this(languageCode: languageCode);

  LocaleState.changeLocale({required this.locale});
}
