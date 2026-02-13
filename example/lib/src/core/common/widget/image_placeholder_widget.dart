import 'package:flutter/material.dart';

import '../../constants/assets.dart';

class ImagePlaceholderWidget extends StatelessWidget {
  final double displayHeight;
  final double displayWidth;
  const ImagePlaceholderWidget({super.key, required this.displayHeight, required this.displayWidth});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        Assets.imagePlaceholder,
        fit: BoxFit.contain,
        height: displayHeight,
        width: displayWidth,
      );
  }
}