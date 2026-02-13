import 'package:flutter/material.dart';

import 'auth_text_field.dart';

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    required this.controller,
    required this.isVisible,
    this.label = 'Password',
    this.hintText,
    this.validator,
    this.textInputAction,
    super.key, required this.onChanged,
  });

  final TextEditingController controller;
  final Function(String text) onChanged;
  final ValueNotifier<bool> isVisible;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isVisible,
      builder: (context, visible, _) {
        return AuthTextField(
          controller: controller,
          label: label,
          hintText: hintText,
          obscureText: !visible,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged ,
          suffixIcon: IconButton(
            onPressed: () => isVisible.value = !visible,
            icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
          ),
        );
      },
    );
  }
}
