import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static SharedPreferences? _instance;

  //Initialize preferences(call this in the main)
  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_instance == null) {
      throw Exception('PreferencesServices not initialized. Call init() first');
    }
    return _instance!;
  }

  //Save simple values
  static Future<bool> setString(String key, String value) {
    return instance.setString(key, value);
  }

  static String? getString(String key) {
    return instance.getString(key);
  }

  //Save complex object as JSON
  static Future<bool> setObject<T>(String key, T object) {
    final jsonString = jsonEncode(object);
    return setString(key, jsonString);
  }

  static T? getObject<T>(
      String key, T Function(Map<String, dynamic>) fromJson) {
    final jsonString = getString(key);
    if (jsonString == null) return null;

    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      print('Error Parsing stored object: $e');
      return null;
    }
  }
}
