import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static Future<void> setString(String key, String value) async {
    final prefs = sl<SharedPreferences>();
    await prefs.setString(key, value);
  }

  static String? getStringSync(String key) {
    final prefs = sl<SharedPreferences>();
    return prefs.getString(key);
  }

  static Future<String?> getString(String key) async {
    final prefs = sl<SharedPreferences>();
    return prefs.getString(key);
  }

  static Future<void> remove(String key) async {
    final prefs = sl<SharedPreferences>();
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = sl<SharedPreferences>();
    await prefs.clear();
  }
}
