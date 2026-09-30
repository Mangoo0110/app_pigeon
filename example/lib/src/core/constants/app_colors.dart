import 'package:flutter/material.dart';

class AppColors {
  static final Color _primaryColor = Color(
    0xFF6666FF,
  ); //Color.fromARGB(255, 58, 64, 234);
  //static const Color _actionColor =  Colors.orange;
  static final AppColors _lightInstance = AppColors._internalLight();
  static final AppColors _darkInstance = AppColors._internalDark();

  factory AppColors.light() {
    return _lightInstance;
  }

  factory AppColors.dark() {
    return _darkInstance;
  }

  /// Returns the correct [AppColors] instance based on the [ThemeData.brightness]
  ///
  /// .
  ///
  /// .
  ///#### [Note]
  ///
  /// Normally you don't need this, if you have used [light] or [dark] named constructors in the themedata that you used in the [MaterialApp]
  ///
  /// If you want to get the colors based on the current theme, use this constructor instead of  [light] or [dark]
  /// Below is an example of how to use it, if you have both lighttheme and darktheme in the app
  ///
  ///
  /// #### example code:
  /// ```dart
  /// AppColors appColors = AppColors.context(context);
  /// ```
  /// Now somewhere in the widget tree, use that [appColors] object to get the correct colors...
  /// ```dart
  /// Container(
  ///   color: appColors.backgroundColor,
  ///   child: Text("Hello", style: TextStyle(color: appColors.textColor)),
  /// )
  /// ```
  factory AppColors.context(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _darkInstance
        : _lightInstance;
  }
  final Color secondaryColor = _primaryColor.withAlpha(150);
  final Color textColor;
  final Color invertTextColor;
  final Color grey;
  final Color backgroundColor;
  final Color tileColor;
  final Color softGrey;
  final Color iconColor;
  // final Color primaryColor;
  //static Color _primaryColor = _primaryColor;
  Color get primaryColor => _primaryColor;
  Color get splashColor => Color.fromARGB(150, 200, 201, 201);
  final Color buttonContentColor;
  final Color unselectedTileColor = Color.fromARGB(255, 225, 244, 254);
  Color activeButtonColor = _primaryColor;
  final Color bottomNavigationBarColor = _primaryColor;
  final Color unselectedLabelColor = Color.fromARGB(255, 89, 89, 89);
  final Color activeButtonContentColor;
  final Color inActiveButtonColor;
  final Color inActiveButtonContentColor;
  final Color buttonColor = _primaryColor;
  final Color drawerColor;
  final Color fillColor = Colors.transparent;
  final Color hintColor = Color.from(
    alpha: 1,
    red: 0.451,
    green: 0.451,
    blue: 0.451,
  );
  final Color labelColor = Color.from(
    alpha: 1,
    red: 0.451,
    green: 0.451,
    blue: 0.451,
  );
  final Color focusedBorderColor = _primaryColor;
  final Color enabledBorderColor = Color.from(
    alpha: 1,
    red: 0.749,
    green: 0.749,
    blue: 0.749,
  );
  final Color borderColor;
  final Color popupBackgroundColor;
  final Color popupContentColor;
  final Color dividerColor;
  final Color tabBarColor;
  final Color shadowColor;
  final Color errorColor;

  AppColors._internalLight()
    : textColor = Colors.black,
      invertTextColor = Colors.white,
      grey = Color.fromARGB(255, 162, 158, 158),
      tileColor = Color(0xFFB0E0CF),
      softGrey = Color.fromARGB(255, 233, 233, 233),
      backgroundColor = Colors.white,
      iconColor = Color(0xFF0F0F79),
      buttonContentColor = Colors.white,
      activeButtonContentColor = Colors.white,
      inActiveButtonContentColor = Colors.grey.shade200,
      inActiveButtonColor = Colors.grey.shade700,
      drawerColor = Colors.white,
      borderColor = Colors.grey.shade700,
      dividerColor = Colors.grey.shade200,
      popupBackgroundColor = Colors.grey.shade200,
      popupContentColor = Colors.black,
      shadowColor = const Color(0x1F000000),
      errorColor = Colors.red,
      tabBarColor = Colors.white;

  AppColors._internalDark()
    : textColor = Colors.white,
      invertTextColor = Colors.black,
      grey = Colors.grey,
      backgroundColor = Color.fromARGB(255, 17, 22, 31), //Colors.black,
      tileColor = Colors.grey.shade900,
      softGrey = Colors.grey.shade500,
      iconColor = Color(0xFF0F0F79),
      buttonContentColor = Colors.black,
      activeButtonContentColor = Colors.white,
      inActiveButtonContentColor = Colors.grey.shade500,
      inActiveButtonColor = Colors.grey.shade900,
      drawerColor = Colors.black,
      borderColor = Colors.grey.shade400,
      dividerColor = Colors.grey.shade900,
      errorColor = Colors.red,
      popupBackgroundColor = Colors.black,
      popupContentColor = Colors.white,
      shadowColor = const Color.fromARGB(146, 124, 123, 123),
      tabBarColor = Colors.black;
}
