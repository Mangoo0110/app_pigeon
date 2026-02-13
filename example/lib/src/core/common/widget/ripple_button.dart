import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class RippleTextButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onPressed;

  const RippleTextButton({
    super.key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          animationDuration: const Duration(milliseconds: 140),

          // pill shape
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),

          backgroundColor: WidgetStateProperty.resolveWith((states) {
            final base = AppColors.context(context).primaryColor;

            // subtle darken on press
            if (states.contains(WidgetState.pressed)) {
              return Color.alphaBlend(Colors.black.withAlpha(25), base);
            }

            // tiny change on hover (web/desktop)
            if (states.contains(WidgetState.hovered)) {
              return Color.alphaBlend(Colors.white.withAlpha(2), base);
            }

            return base;
          }),

          foregroundColor: WidgetStatePropertyAll(
            AppColors.context(context).invertTextColor,
          ),

          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return 2;
            if (states.contains(WidgetState.hovered)) return 8;
            if (states.contains(WidgetState.focused)) return 10;
            return 10;
          }),

          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black.withAlpha(6); // ripple overlay
            }
            if (states.contains(WidgetState.hovered)) {
              return Colors.black.withAlpha(4);
            }
            return null;
          }),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
