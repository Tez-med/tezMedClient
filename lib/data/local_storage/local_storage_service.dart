import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_med_client/injection.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  final _preferences = getIt<SharedPreferences>();

  // Singleton pattern
  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();
    return _instance!;
  }

  // String type data
  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _preferences.getString(key) ?? defaultValue;
  }

  // Int type data
  Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _preferences.getInt(key) ?? defaultValue;
  }

  // Boolean type data
  Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _preferences.getBool(key) ?? defaultValue;
  }

  // Double type data
  Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _preferences.getDouble(key) ?? defaultValue;
  }

  // Clear specific key
  Future<bool> removeKey(String key) async {
    return await _preferences.remove(key);
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _preferences.clear();
  }

  // Check if key exists
  bool hasKey(String key) {
    return _preferences.containsKey(key);
  }
}
