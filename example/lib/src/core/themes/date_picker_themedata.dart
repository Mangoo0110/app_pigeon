part of 'themes.dart';

class DatePickerThemes {
  static final lightTheme = DatePickerThemeData(
    backgroundColor: AppColors.light().backgroundColor,
    headerBackgroundColor: AppColors.light().primaryColor,
    headerForegroundColor: Colors.black,
    dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade300;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.light().primaryColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.light().primaryColor.withAlpha(125);
        }
        return Colors.transparent; // default background
      },
    ),
    dayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.light().primaryColor;
        }
        return AppColors.light().textColor; // default background
      },
    ),
    
    todayBorder: BorderSide(color: AppColors.light().primaryColor),
    todayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.light().primaryColor;
        }
        return AppColors.light().primaryColor; // default background
      },
    ),
    todayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.light().primaryColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.light().primaryColor.withAlpha(125);
        }
        return Colors.transparent; // default background
      },
    ),
    
    rangeSelectionBackgroundColor: AppColors.light().primaryColor.withAlpha(50),
    yearForegroundColor: WidgetStatePropertyAll(Colors.black),
    yearBackgroundColor: WidgetStatePropertyAll(Colors.transparent),
    yearOverlayColor: WidgetStatePropertyAll(AppColors.light().primaryColor.withAlpha(50)),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.light().grey),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.light().primaryColor),
    )
  );

  static final darkTheme = DatePickerThemeData(
    backgroundColor: AppColors.dark().backgroundColor,
    headerBackgroundColor: AppColors.dark().primaryColor,
    headerForegroundColor: Colors.white,
    dayForegroundColor: WidgetStatePropertyAll(Colors.white),
    todayForegroundColor: WidgetStatePropertyAll(Colors.transparent),
    todayBorder: BorderSide(color: AppColors.light().primaryColor),
    todayBackgroundColor: WidgetStatePropertyAll(AppColors.dark().primaryColor.withAlpha(155)),
    rangeSelectionBackgroundColor: AppColors.dark().primaryColor.withAlpha(50),
    yearForegroundColor: WidgetStatePropertyAll(Colors.white),
    yearBackgroundColor: WidgetStatePropertyAll(Colors.transparent),
    yearOverlayColor: WidgetStatePropertyAll(AppColors.dark().primaryColor.withAlpha(50)),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.light().grey),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.light().primaryColor),
    )
  );
}
