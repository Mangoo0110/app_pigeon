import 'package:flutter/material.dart';

class LoginFormState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
  }

  bool validate() => formKey.currentState?.validate() ?? false;
}

class SignupFormState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
  }

  bool validate() => formKey.currentState?.validate() ?? false;
}

class ForgotPasswordFormState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  void dispose() {
    emailController.dispose();
  }

  bool validate() => formKey.currentState?.validate() ?? false;
}

class ResetPasswordFormState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

  void dispose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    isPasswordVisible.dispose();
  }

  bool validate() => formKey.currentState?.validate() ?? false;
}

class EmailVerificationFormState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  void dispose() {
    userIdController.dispose();
    codeController.dispose();
  }

  bool validate() => formKey.currentState?.validate() ?? false;
}

class SocialLoginFormState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController accessTokenController = TextEditingController();
  final TextEditingController idTokenController = TextEditingController();
  String provider = 'google';

  void dispose() {
    accessTokenController.dispose();
    idTokenController.dispose();
  }

  bool validate() => formKey.currentState?.validate() ?? false;
}
