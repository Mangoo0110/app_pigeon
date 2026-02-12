import 'package:example/src/core/utils/extensions/validation.dart';

class AuthValidators {
  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Email is required';
    }
    if (!text.isEmail()) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  static String? strongPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Password is required';
    }
    if (!text.isStrongPassword()) {
      return 'Use 8+ chars with upper, lower, number, symbol';
    }
    return null;
  }

  static String? fullName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Full name is required';
    }
    if (text.length < 2) {
      return 'Full name is too short';
    }
    return null;
  }

  static String? verificationCode(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Verification code is required';
    }
    return null;
  }

  static String? userId(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'User ID is required';
    }
    return null;
  }
}
