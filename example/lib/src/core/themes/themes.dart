import '../utils/extensions/textstyle_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
part 'date_picker_themedata.dart';
part 'elevated_button_themes.dart';
part 'floating_action_button_theme.dart';
part 'progress_indicator_theme.dart';
part 'appbar_theme.dart';
part 'bottom_appbar_theme.dart';
part 'bottom_navigation_bar_theme.dart';
part 'bottomsheet_theme.dart';
part 'button_theme.dart';
part 'card_theme.dart';
part 'checkbox_theme.dart';
part 'divider_theme.dart';
part 'icon_theme.dart';
part 'input_decoration_theme.dart';
part 'switch_theme.dart';
part 'tabbar_theme.dart';
part 'text_theme.dart';
part 'text_selection_theme.dart';
part 'slider_theme.dart';

class AppTheme {
  AppTheme();

  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.light().primaryColor,
      primaryTextTheme: DTextTheme.lightTextTheme,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.light().primaryColor,
        ),
      ),

      primaryColorLight: AppColors.light().primaryColor,
      primaryColorDark: AppColors.light().primaryColor,
      splashColor: AppColors.light().splashColor,
      highlightColor: AppColors.light().splashColor,
      hoverColor: AppColors.light().splashColor,
      focusColor: AppColors.light().splashColor,
      shadowColor: AppColors.light().shadowColor,
      dividerColor: AppColors.light().dividerColor,
      cardColor: AppColors.light().tileColor,

      useMaterial3: true,
      fontFamily: 'Public Sans',
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(AppColors.light().primaryColor.value, {
          50: AppColors.light().primaryColor.withAlpha(25),
          100: AppColors.light().primaryColor.withAlpha(50),
          200: AppColors.light().primaryColor.withAlpha(76),
          300: AppColors.light().primaryColor.withAlpha(102),
          400: AppColors.light().primaryColor.withAlpha(128),
          500: AppColors.light().primaryColor,
          600: AppColors.light().primaryColor,
          700: AppColors.light().primaryColor,
          800: AppColors.light().primaryColor,
          900: AppColors.light().primaryColor,
        }),
        accentColor: AppColors.light().primaryColor,
        backgroundColor: AppColors.light().backgroundColor,
        cardColor: AppColors.light().backgroundColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.light().backgroundColor,
      textTheme: DTextTheme.lightTextTheme,
      textSelectionTheme: DTextSelectionTheme.lightTextSelectionTheme,
      switchTheme: SwitchThemes.lightSwitchTheme,
      appBarTheme: DAppBarTheme.lightAppBarTheme,
      bottomAppBarTheme: DBottomAppBarTheme.lightBottomAppBarTheme,
      inputDecorationTheme: DInputDecorationTheme.lightTheme,
      iconTheme: DIconTheme.lightIconTheme,
      buttonTheme: DButtonTheme.lightButtonTheme,
      bottomSheetTheme: DBottomSheetTheme.lightBottomSheetTheme,
      checkboxTheme: DCheckboxTheme.lightCheckboxTheme,
      //cardTheme: DCardTheme.lightCardTheme,
      bottomNavigationBarTheme: DBottomNavigationBarThemes.lightBottomNavTheme,
      tabBarTheme: DTabBarTheme.lightTabBarTheme,
      listTileTheme: ListTileThemeData(
        selectedTileColor: AppColors.light().splashColor,
      ),
      indicatorColor: AppColors.light().backgroundColor,
      dividerTheme: DDividerTheme.lightDividerTheme,
      progressIndicatorTheme: ProgressIndicatorThemes.light,
      datePickerTheme: DatePickerThemes.lightTheme,
      elevatedButtonTheme: ElevatedButtonThemes.light,
      floatingActionButtonTheme: FloatingActionButtonThemes.lightTheme,
      sliderTheme: AppSliderTheme.lightTheme,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.dark().primaryColor,
      primarySwatch: MaterialColor(AppColors.light().primaryColor.toARGB32(), {
        50: AppColors.light().primaryColor.withAlpha(25),
        100: AppColors.light().primaryColor.withAlpha(50),
        200: AppColors.light().primaryColor.withAlpha(76),
        300: AppColors.light().primaryColor.withAlpha(102),
        400: AppColors.light().primaryColor.withAlpha(128),
        500: AppColors.light().primaryColor,
        600: AppColors.light().primaryColor,
        700: AppColors.light().primaryColor,
        800: AppColors.light().primaryColor,
        900: AppColors.light().primaryColor,
      }),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.light().primaryColor,
        ),
      ),
      primaryTextTheme: DTextTheme.darkTextTheme,
      primaryColorLight: AppColors.dark().textColor,
      primaryColorDark: AppColors.dark().backgroundColor,
      splashColor: AppColors.dark().splashColor,
      highlightColor: AppColors.dark().primaryColor.withAlpha(175),
      hoverColor: AppColors.dark().primaryColor.withAlpha(175),
      focusColor: AppColors.dark().primaryColor.withAlpha(175),
      shadowColor: AppColors.dark().shadowColor,
      dividerColor: AppColors.dark().dividerColor,
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSwatch(
        accentColor: AppColors.dark().primaryColor,
        backgroundColor: AppColors.dark().backgroundColor,
        cardColor: AppColors.dark().backgroundColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.dark().backgroundColor,
      textTheme: DTextTheme.darkTextTheme,
      switchTheme: SwitchThemes.darkSwitchTheme,
      appBarTheme: DAppBarTheme.darkAppBarTheme,
      bottomAppBarTheme: DBottomAppBarTheme.darkBottomAppBarTheme,
      inputDecorationTheme: DInputDecorationTheme.darkTheme,
      iconTheme: DIconTheme.darkIconTheme,
      textSelectionTheme: DTextSelectionTheme.darkTextSelectionTheme,
      buttonTheme: DButtonTheme.darkButtonTheme,
      bottomSheetTheme: DBottomSheetTheme.darkBottomSheetTheme,
      checkboxTheme: DCheckboxTheme.darkCheckboxTheme,
      // cardTheme: DCardTheme.darkCardTheme,
      tabBarTheme: DTabBarTheme.darkTabBarTheme,
      bottomNavigationBarTheme: DBottomNavigationBarThemes.darkBottomNavTheme,
      dividerTheme: DDividerTheme.darkDividerTheme,
      indicatorColor: AppColors.dark().textColor,
      progressIndicatorTheme: ProgressIndicatorThemes.dark,
      datePickerTheme: DatePickerThemes.darkTheme,
      elevatedButtonTheme: ElevatedButtonThemes.dark,
      sliderTheme: AppSliderTheme.darkTheme,
    );
  }
}
