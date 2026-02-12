part of 'themes.dart';

class DTabBarTheme {
  DTabBarTheme._(); // Private constructor

  // Light TabBarTheme
  static TabBarThemeData lightTabBarTheme = TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: AppColors.light().bottomNavigationBarColor,
    indicator: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
    ), // Color of the tab indicator
    labelColor: Colors.white, // Color of the selected tab's label
    unselectedLabelColor: Color.from(alpha: 1, red: 0.349, green: 0.349, blue: 0.349), // Color of the unselected tab's label
    labelStyle: const TextStyle(fontSize: 13, fontFamily: "Poppins", fontWeight: FontWeight.normal), // Style of the selected tab's label
    unselectedLabelStyle: const TextStyle(fontSize: 13, fontFamily: "Poppins", fontWeight: FontWeight.normal), // Style of the unselected tab's label
  );

  // Dark TabBarTheme
  static TabBarThemeData darkTabBarTheme = TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.label,
    indicator: BoxDecoration(
      color: AppColors.dark().primaryColor,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
    ),
    dividerColor: AppColors.light().bottomNavigationBarColor,
    labelColor: AppColors.dark().primaryColor, // Color of the selected tab's label
    unselectedLabelColor: Color.from(alpha: 1, red: 0.349, green: 0.349, blue: 0.349),  // Color of the unselected tab's label
    labelStyle: const TextStyle(fontSize: 13, fontFamily: "Poppins", fontWeight: FontWeight.normal), // Style of the selected tab's label
    unselectedLabelStyle: const TextStyle(fontSize: 13, fontFamily: "Poppins", fontWeight: FontWeight.normal), // Style of the unselected tab's label
  );
}