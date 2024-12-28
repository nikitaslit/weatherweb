import 'package:shared_preferences/shared_preferences.dart';

class KeyStore {
  KeyStore._();

  static const String currentTheme = 'useMaterial3';
  static const bool currentThemeDefault = false; // По умолчанию светлая тема

  static Future<void> saveThemeStorage(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KeyStore.currentTheme, isDarkMode); // Сохраняем как bool
  }

  static Future<bool> loadThemeStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KeyStore.currentTheme) ?? KeyStore.currentThemeDefault; // Возвращаем bool
  }
}
