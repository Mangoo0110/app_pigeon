import 'package:flutter/material.dart';

class ProfileAvatarAction extends StatelessWidget {
  const ProfileAvatarAction({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: "Profile",
      icon: CircleAvatar(
        radius: 14,
        child: Text(
          label.isEmpty ? "U" : label[0].toUpperCase(),
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
