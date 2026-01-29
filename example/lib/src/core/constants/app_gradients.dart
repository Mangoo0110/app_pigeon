import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static final shimmerGradiant = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.light().primaryColor.withAlpha(50),
      Colors.black,
      AppColors.light().primaryColor.withAlpha(50),
    ] 
  );
}
