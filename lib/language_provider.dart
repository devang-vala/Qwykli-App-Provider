
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortly_provider/core/app_imports.dart';

class LanguageChangeProvider with ChangeNotifier {
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
}
