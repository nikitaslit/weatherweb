import 'package:shared_preferences/shared_preferences.dart';

class KeyStores {
  KeyStores._();

  static const String currentCity = 'currentCity'; //текущий город мой
  static const String currentCityDefault = 'Пермь'; // по умолчанию город

  static Future<void> saveCityStorage(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KeyStores.currentCity, city);
  }

  static Future<String> loadCityStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KeyStores.currentCity) ?? KeyStores.currentCityDefault;
  }

}