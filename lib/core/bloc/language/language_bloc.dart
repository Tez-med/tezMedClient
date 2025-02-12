import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageInitial(Locale('uz'))) {
    on<ChangeLanguage>(_onLanguageChanged);
    _loadSavedLanguage();
  }

  Future<void> _onLanguageChanged(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    emit(LanguageUpdated(event.locale));

    await _saveLanguageToPreferences(event.locale);
  }

  Future<void> _saveLanguageToPreferences(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', locale.languageCode);
  }

  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selected_language');
    if (languageCode != null) {
      Locale savedLocale = Locale(languageCode);
      add(ChangeLanguage(savedLocale));
    }
  }

  // Hozirgi tilni qaytarish
  Locale getCurrentLanguage() {
    return state.locale;
  }
}
