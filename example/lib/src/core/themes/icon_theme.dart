part of 'themes.dart';

class DIconTheme {
  DIconTheme._(); // Private constructor

  // Light IconThemeData
  static IconThemeData lightIconTheme = IconThemeData(
    color: AppColors.light().iconColor, // Color of the icon
    size: 24, // Size of the icon
    opacity: 1.0, // Opacity of the icon
    shadows: [ // Shadows applied to the icon
      // Shadow(
      //   color: Colors.black.withOpacity(0.2),
      //   offset: Offset(0, 1),
      //   blurRadius: 2,
      // ),
    ],
  );

  // Dark IconThemeData
  static IconThemeData darkIconTheme = IconThemeData(
    color: AppColors.dark().iconColor, // Color of the icon
    size: 24, // Size of the icon
    opacity: 1.0, // Opacity of the icon
    shadows: [ // Shadows applied to the icon
      // Shadow(
      //   color: Colors.black.withOpacity(0.4),
      //   offset: Offset(0, 1),
      //   blurRadius: 3,
      // ),
    ],
  );
}