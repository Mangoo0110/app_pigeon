part of 'themes.dart';

class DBottomAppBarTheme {
  DBottomAppBarTheme._(); // Private constructor

  // Light BottomAppBarThemeData
  
  static BottomAppBarThemeData lightBottomAppBarTheme = BottomAppBarThemeData(
    color: AppColors.light().backgroundColor,
    elevation: 8,
    shadowColor: AppColors.light().backgroundColor,
    shape: const CircularNotchedRectangle(),
  );

  // Dark BottomAppBarThemeData
  static BottomAppBarThemeData darkBottomAppBarTheme = BottomAppBarThemeData(
    color: AppColors.dark().dividerColor,
    elevation: 8,
    shadowColor: AppColors.dark().dividerColor,
    surfaceTintColor: AppColors.dark().dividerColor,
    shape: const CircularNotchedRectangle(),
  );
}