import 'package:flutter/material.dart';
import 'package:app_pigeon/app_pigeon.dart';

class AuthAccountTile extends StatelessWidget {
  const AuthAccountTile({
    required this.auth,
    required this.onSwitch,
    super.key,
  });

  final Auth auth;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final data = auth.data;
    final title = data['email']?.toString() ?? 'Account';
    final subtitle = data['name']?.toString() ?? data['id']?.toString();
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: TextButton(onPressed: onSwitch, child: const Text('Switch')),
    );
  }
}
