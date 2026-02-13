part of 'themes.dart';

class DCheckboxTheme {
  DCheckboxTheme._(); // Private constructor

  // Light CheckboxThemeData
  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    fillColor: WidgetStatePropertyAll(AppColors.light().buttonColor),
    checkColor: WidgetStatePropertyAll(AppColors.light().textColor),
    splashRadius: 20,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );

  // Dark CheckboxThemeData
  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    fillColor: WidgetStatePropertyAll(AppColors.dark().buttonColor),
    checkColor: WidgetStatePropertyAll(AppColors.dark().textColor),
    splashRadius: 20,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );
}