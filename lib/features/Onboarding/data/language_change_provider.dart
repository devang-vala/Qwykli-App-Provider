import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeProvider extends ChangeNotifier {
  String _selectedLang = 'en';

  String get selectedLang => _selectedLang;

  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _appLocale = type;
    if (type == Locale('en')) {
      await sp.setString('lang', 'en');
    } else {
      await sp.setString('lang', 'ar');
    }
    notifyListeners();
  }

  void setLang(String langCode) {
    _selectedLang = langCode;
    notifyListeners();
  }
}
