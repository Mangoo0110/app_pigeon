part of 'themes.dart';

class DTextSelectionTheme {
  DTextSelectionTheme._(); // Private constructor

  static TextSelectionThemeData lightTextSelectionTheme = TextSelectionThemeData(
    cursorColor: AppColors.light().primaryColor,
    selectionColor: AppColors.light().primaryColor.withAlpha(175),
    selectionHandleColor: AppColors.light().primaryColor.withAlpha(175),
  );

  static TextSelectionThemeData darkTextSelectionTheme = TextSelectionThemeData(
    cursorColor: AppColors.dark().primaryColor,
    selectionColor: AppColors.dark().primaryColor.withAlpha(175),
    selectionHandleColor: AppColors.dark().primaryColor.withAlpha(175),

  );
}
