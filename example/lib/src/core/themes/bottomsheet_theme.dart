part of 'themes.dart';

class DBottomSheetTheme {
  DBottomSheetTheme._(); // Private constructor

  // Light BottomSheetThemeData
  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColors.light().backgroundColor,
    modalBackgroundColor: AppColors.light().backgroundColor,
    elevation: 16,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );

  // Dark BottomSheetThemeData
  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColors.dark().backgroundColor,
    modalBackgroundColor: AppColors.dark().backgroundColor,
    elevation: 16,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}