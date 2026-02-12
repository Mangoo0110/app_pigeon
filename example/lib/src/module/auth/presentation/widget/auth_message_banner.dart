import 'package:flutter/material.dart';

class AuthMessageBanner extends StatelessWidget {
  const AuthMessageBanner({
    required this.message,
    this.color,
    super.key,
  });

  final String? message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message!,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
