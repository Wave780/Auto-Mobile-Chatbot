import 'package:auto_mobile_chatbot/service/preference.dart';
import 'package:auto_mobile_chatbot/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, AppThemes>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppThemes> {
  final String _themeKey = 'app_theme';

  ThemeNotifier() : super(AppThemes.defaultTheme()) {
    _loadTheme();
  }

  //Load theme from storage
  Future<void> _loadTheme() async {
    final savedTheme = PreferenceService.getObject<AppThemes>(
      _themeKey,
      (json) => AppThemes.fromJson(json),
    );
    if (savedTheme != null) {
      state = savedTheme;
    }
  }

  //Save theme Storage
  Future<void> _saveTheme() async {
    await PreferenceService.setObject(_themeKey, state.toJson());
  }

//toggle dark mode
  Future<void> toggleDarkMode() async {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    await _saveTheme();
  }

  //Change Primary color
  Future<void> setPrimaryColor(String color) async {
    state = state.copyWith(primaryColor: color);
    await _saveTheme();
  }

  //Change font
  Future<void> setFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    await _saveTheme();
  }

  //Change font family
  Future<void> setFontFamily(String family) async {
    state = state.copyWith(fontFamily: family);
    await _saveTheme();
  }

  //Reset to default
  Future<void> reset() async {
    state = AppThemes.defaultTheme();
    await _saveTheme();
  }
}
