import 'package:flutter/material.dart';

// Палитра цветов
class AppColors {
  static const Color primary = Color(0xFF6200EE); 
  static const Color secondary = Color(0xFF03DAC5); 
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212); 
  static const Color textLight =
      Color(0xFF000000); 
  static const Color textDark =
      Color(0xFFFFFFFF); 
}

class AppTextStyles {
  static const TextStyle bodySmallLight = TextStyle(
    fontSize: 14.0,
    color: AppColors.textLight, 
  );
  static const TextStyle bodySmallDark = TextStyle(
    fontSize: 14.0,
    color: AppColors.textDark, 
  );

  static const TextStyle bodyMediumLight = TextStyle(
    fontSize: 16.0,
    color: Color.fromARGB(255, 81, 68, 68), 
  );
  static const TextStyle bodyMediumDark = TextStyle(
    fontSize: 16.0,
    color: AppColors.textDark, 
  );

  static const TextStyle bodyLargeLight = TextStyle(
    fontSize: 20.0,
    color: Color.fromARGB(255, 74, 59, 59), 
  );
  static const TextStyle bodyLargeDark = TextStyle(
    fontSize: 20.0,
    color: AppColors.textDark, 
  );
}
