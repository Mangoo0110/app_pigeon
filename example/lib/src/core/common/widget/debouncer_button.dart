import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../utils/helpers/debouncer.dart';

class DebouncerButton extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onTap;
  final BorderRadius? borderRadius;
  final Color? splashColor;

  const DebouncerButton({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.splashColor,
  });

  @override
  State<DebouncerButton> createState() => _DebouncerButtonState();
}

class _DebouncerButtonState extends State<DebouncerButton> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  Future<void> _handleTap() async {
    _debouncer.run(() async {
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppSizes.smallRectangleTileRadius;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: widget.splashColor,
        borderRadius: radius,
        onTap: _handleTap,
        child: widget.child,
      ),
    );
  }
}
