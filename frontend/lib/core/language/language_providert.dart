import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  final String _localeKey = 'language_code';

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey) ?? 'en';
    setLocale(savedLocale);
  }

  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode != languageCode) {
      _locale = Locale(languageCode);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
    }
  }
}
