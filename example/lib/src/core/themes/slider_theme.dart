part of 'themes.dart';
class AppSliderTheme {
  static SliderThemeData get lightTheme => SliderThemeData(
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    trackHeight: 5,
    thumbColor: AppColors.light().primaryColor,
    activeTrackColor: AppColors.light().primaryColor,
    inactiveTrackColor: AppColors.light().primaryColor.withAlpha(31),
  );

  static SliderThemeData get darkTheme => SliderThemeData(
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    trackHeight: 5,
    thumbColor: AppColors.dark().primaryColor,
    activeTrackColor: AppColors.dark().primaryColor,
    inactiveTrackColor: AppColors.dark().primaryColor.withAlpha(31),
  );
}