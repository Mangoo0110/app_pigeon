import 'package:flutter/material.dart';

class AuthSectionDivider extends StatelessWidget {
  const AuthSectionDivider({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
