part of 'themes.dart';

class DInputDecorationTheme {
  DInputDecorationTheme._(); // Private constructor

  // Light InputDecorationTheme
  static InputDecorationTheme lightTheme = InputDecorationTheme(
    //filled: true,
    //contentPadding: const EdgeInsets.only(left: 4, right: 4),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    prefixIconConstraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
    contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
    fillColor: Colors.transparent,
    focusColor: AppColors.light().textColor,
    hoverColor: AppColors.light().textColor,
    hintStyle: TextStyle(color: AppColors.light().hintColor),
    labelStyle: TextStyle(color: AppColors.light().labelColor),
    outlineBorder: BorderSide(color: AppColors.light().textColor),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.light().enabledBorderColor),
      borderRadius: AppSizes.textFieldBorderRadius,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.light().enabledBorderColor),
      borderRadius: AppSizes.textFieldBorderRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.light().focusedBorderColor,
        width: 2,
      ),
      borderRadius: AppSizes.textFieldBorderRadius,
    ),
  );

  // Dark InputDecorationTheme
  static InputDecorationTheme darkTheme = InputDecorationTheme(
    //filled: true,
    //contentPadding: const EdgeInsets.only(left: 4, right: 4),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
    fillColor: Colors.transparent,
    focusColor: AppColors.dark().textColor,
    hoverColor: AppColors.dark().textColor,
    hintStyle: TextStyle(color: AppColors.dark().hintColor),
    labelStyle: TextStyle(color: AppColors.dark().labelColor),
    outlineBorder: BorderSide(color: AppColors.dark().textColor),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.dark().enabledBorderColor),
      borderRadius: AppSizes.textFieldBorderRadius,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.dark().enabledBorderColor),
      borderRadius: AppSizes.textFieldBorderRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.dark().focusedBorderColor,
        width: 2,
      ),
      borderRadius: AppSizes.textFieldBorderRadius,
    ),
  );
}
