import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.child,
    this.subtitle,
    this.bottom,
    this.showBack = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? bottom;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBack ? AppBar() : null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: bottom == null
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 24),
                        child,
                      ],
                    ),
                    if (bottom != null) ...[
                      const SizedBox(height: 16),
                      bottom!,
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
