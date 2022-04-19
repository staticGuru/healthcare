import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static SharedPreferences prefs;
  static String token;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static put(String key, dynamic value) async {
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    }
  }

  static Future<String> getString(String key) async {
    String value = prefs.getString(key);
    return value;
  }

  static Future<int> getInt(String key) async {
    return await prefs.getInt(key);
  }

  static Future<double> getDouble(String key) async {
    return await prefs.getDouble(key);
  }

  static Future<bool> getBool(String key) async {
    return await prefs.getBool(key);
  }

  static remove(String key) async {
    prefs.remove(key);
  }

  static clear() async {
    prefs.clear();
  }
}
