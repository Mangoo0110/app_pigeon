part of 'themes.dart';

class FloatingActionButtonThemes {
  static FloatingActionButtonThemeData lightTheme =
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.light().primaryColor,
        shape: CircleBorder(),
        elevation: 6.0,
        iconSize: AppSizes.extraLargeIconSize,
      );

  static FloatingActionButtonThemeData darkTheme =
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.dark().tileColor,
        shape: CircleBorder(),
        elevation: 6.0,
        iconSize: AppSizes.largeIconSize,
      );
}
