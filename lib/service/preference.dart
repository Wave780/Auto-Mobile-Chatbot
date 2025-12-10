import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static late SharedPreferences _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  // -----------------------------
  // Onboarding flag
  // -----------------------------
  static const _onboardingCompleteKey = 'onboardingComplete';

  static Future<void> setOnboardingComplete(bool value) async {
    await _instance.setBool(_onboardingCompleteKey, value);
  }

  static bool getOnboardingComplete() {
    return _instance.getBool(_onboardingCompleteKey) ?? false;
  }

  //Save simple values
  static Future<bool> setString(String key, String value) {
    return _instance.setString(key, value);
  }

  static String? getString(String key) {
    return _instance.getString(key);
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
