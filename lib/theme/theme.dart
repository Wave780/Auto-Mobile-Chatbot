import 'package:flutter/material.dart';

class AppColors {
  // Light Theme
  static const Color primaryLight = Color(0xFF2C2C2C); // ChatGPT green
  static const Color primaryVariantLight = Color(0xFF4A4A4A);
  static const Color secondaryLight = Color(0xFF2C2C2C); // Neutral accent
  static const Color secondaryVariantLight = Color(0xFF4A4A4A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color errorLight = Color(0xFFB00020);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF000000);
  static const Color onBackgroundLight = Color(0xFF000000);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // Dark Theme
  static const Color primaryDark = Color(0xFF10A37F); // Keep same green
  static const Color primaryVariantDark = Color(0xFF0E8C6F);
  static const Color secondaryDark = Color(0xFFCCCCCC); // Light gray text
  static const Color secondaryVariantDark = Color(0xFFAAAAAA);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF000000);
}

// Usage
final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryLight,
    onPrimary: AppColors.onPrimaryLight,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.onSecondaryLight,
    error: AppColors.errorLight,
    onError: AppColors.onErrorLight,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.onSurfaceLight,
    background: AppColors.backgroundLight,
    onBackground: AppColors.onBackgroundLight,
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.onPrimaryDark,
    secondary: AppColors.secondaryDark,
    onSecondary: AppColors.onSecondaryDark,
    error: AppColors.errorDark,
    onError: AppColors.onErrorDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
    background: AppColors.backgroundDark,
    onBackground: AppColors.onBackgroundDark,
  ),
);

final ThemeData textThem = ThemeData(
  textTheme: TextTheme(
// Headlines
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    headlineSmall: TextStyle(
      //color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
    ),

// Body text
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontFamily: 'Inter',
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: 'Inter',
      height: 1.4,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontFamily: 'Inter',
      height: 1.3,
    ),

// Labels
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
    ),
  ),
);

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
