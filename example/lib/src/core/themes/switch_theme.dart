part of 'themes.dart';

class SwitchThemes {
  static SwitchThemeData lightSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.light().primaryColor; // Thumb color when selected
      }
      return Colors.grey; // Thumb color when not selected
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.light().primaryColor.withAlpha(50); // Track color when selected
      }
      return Colors.grey.withAlpha(128); // Track color when not selected
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.light().primaryColor.withAlpha(200); // Track color when selected
      }
      return Colors.grey.withAlpha(128); // Track color when not selected
    }),
  );

  static SwitchThemeData darkSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.dark().primaryColor; // Thumb color when selected
      }
      return Colors.white; // Thumb color when not selected
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.dark().primaryColor.withAlpha(50); // Track color when selected
      }
      return Colors.white.withAlpha(80); // Track color when not selected
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.dark().primaryColor.withAlpha(200); // Track color when selected
      }
      return Colors.white.withAlpha(80); // Track color when not selected
    }),
  );
}