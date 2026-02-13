part of 'themes.dart';

class DAppBarTheme {
  DAppBarTheme._(); // Private constructor

  // Light AppBarTheme
  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.light().backgroundColor,
    //foregroundColor: AppColors.light().primaryColor,
    surfaceTintColor:
        AppColors.light().backgroundColor, //AppColors.light().backgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: AppColors.light().backgroundColor,
      statusBarIconBrightness: Brightness.light,
    ),

    //elevation: 0,
    //titleSpacing: 0,
    iconTheme: IconThemeData(color: AppColors.light().textColor, size: 18),
    actionsIconTheme: IconThemeData(
      color: AppColors.light().textColor,
      size: 18,
    ),
    toolbarTextStyle: TextStyle(color: AppColors.light().textColor),
    titleTextStyle: TextStyle(color: AppColors.light().textColor).w600.regular,
    centerTitle: true,
  );

  // Dark AppBarTheme
  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.dark().backgroundColor,
    surfaceTintColor: AppColors.dark().backgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: AppColors.light().backgroundColor,
      statusBarIconBrightness: Brightness.dark,
    ),
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.dark().textColor, size: 18),
    actionsIconTheme: IconThemeData(
      color: AppColors.dark().iconColor,
      size: 18,
    ),
    toolbarTextStyle: TextStyle(color: AppColors.dark().textColor),
    titleTextStyle: TextStyle(
      color: AppColors.dark().invertTextColor,
    ).w600.regular,
    centerTitle: true,
    // bottom: PreferredSize(
    //   preferredSize: Size.fromHeight(kToolbarHeight),
    //   child: Container(),
    // ),
  );

  static AppBarTheme getAppBarTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightAppBarTheme : darkAppBarTheme;
  }
}
