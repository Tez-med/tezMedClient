part of 'language_bloc.dart';

abstract class LanguageState {
  final Locale locale;

  const LanguageState(this.locale);
}

class LanguageInitial extends LanguageState {
  const LanguageInitial(super.locale);
}

class LanguageUpdated extends LanguageState {
  const LanguageUpdated(super.locale);
}