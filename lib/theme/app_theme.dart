import 'package:flutter/material.dart';

class AppThemes {
  final bool isDarkMode;
  final String primaryColor;
  final double fontSize;
  final String fontFamily;

  AppThemes({
    required this.isDarkMode,
    required this.primaryColor,
    required this.fontSize,
    required this.fontFamily,
  });

  //Convent to/from JSON for storage
  Map<String, dynamic> toJson() {
    return {
      "isDarkMode": isDarkMode,
      "primaryColor": primaryColor,
      "fontSize": fontSize,
      "fontFamily": fontFamily,
    };
  }

  factory AppThemes.fromJson(Map<String, dynamic> json) {
    return AppThemes(
      isDarkMode: json["isDarkMode"] ?? false,
      primaryColor: json["primaryColor"] ?? 'blue',
      fontSize: json["fontSize"] ?? 16.0,
      fontFamily: json["fontFamily"] ?? 'Roboto',
    );
  }

  //Default theme
  factory AppThemes.defaultTheme() {
    return AppThemes(
        isDarkMode: false,
        primaryColor: 'blue',
        fontSize: 16.0,
        fontFamily: 'Roboto');
  }

//Copy with changes
  AppThemes copyWith({
    bool? isDarkMode,
    String? primaryColor,
    double? fontSize,
    String? fontFamily,
  }) {
    return AppThemes(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryColor: primaryColor ?? this.primaryColor,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  ThemeData toThemeData() {
    final primarySwatch = _getPrimarySwatch(primaryColor);

    return ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: primarySwatch,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: fontSize, fontFamily: fontFamily),
          bodyMedium: TextStyle(fontSize: fontSize - 2, fontFamily: fontFamily),
          bodySmall: TextStyle(fontSize: fontSize - 4, fontFamily: fontFamily),
        ));
  }

  MaterialColor _getPrimarySwatch(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
