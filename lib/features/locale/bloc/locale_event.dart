part of "locale_bloc.dart";

abstract class LocaleEvent {}

class ChangedLocaleEvent extends LocaleEvent {
  final Locale newLocale;

  ChangedLocaleEvent({required this.newLocale});
}
