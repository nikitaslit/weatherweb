import 'package:flutter/material.dart';
import 'package:flutter_test_zadanie/feature/theme/app_colors.dart';

class AppTheme {
  // Светлая тема
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        titleTextStyle: TextStyle(
            color: const Color.fromARGB(255, 57, 50, 50), fontSize: 20),
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: TextTheme(
        bodySmall:
            AppTextStyles.bodySmallLight, 
        bodyMedium: AppTextStyles
            .bodyMediumLight, 
        bodyLarge:
            AppTextStyles.bodyLargeLight,
      ),
    );
  }

  // Темная тема
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      appBarTheme: AppBarTheme(
        backgroundColor:
            const Color.fromARGB(255, 113, 43, 43), 
        titleTextStyle: TextStyle(color: AppColors.textDark, fontSize: 20),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 118, 87, 87),
      textTheme: TextTheme(
        bodySmall:
            AppTextStyles.bodySmallDark, 
        bodyMedium:
            AppTextStyles.bodyMediumDark,
        bodyLarge:
            AppTextStyles.bodyLargeDark, 
      ),
    );
  }
}
