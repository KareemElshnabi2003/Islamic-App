import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // ================== LIGHT THEME ==================
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.primaryLight,
      primaryColor: AppColors.bottomNavigationLight,
      dividerColor: AppColors.lineLight,



      secondaryHeaderColor: AppColors.imgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
      ),

      // تظبيط شكل الـ AppBar في اللايت
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.iconLight),
      ),

      // تظبيط شكل الـ Text بشكل عام
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textMainLight),
        bodyMedium: TextStyle(color: AppColors.textSecondaryLight),
      ),
    );
  }

  // ================== DARK THEME ==================
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bottomNavigationDark,
      primaryColor: AppColors.primaryDark,
      secondaryHeaderColor: AppColors.imgDark,
      dividerColor: AppColors.lineDark,


      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,


      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.iconDark),      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textMainDark),
        bodyMedium: TextStyle(color: AppColors.textSecondaryDark),
      ),
    );
  }
}