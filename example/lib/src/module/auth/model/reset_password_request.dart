class ResetPasswordRequest {
  final String email;
  final String verificationCode;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.verificationCode,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'verification_code': verificationCode,
      'new_password': newPassword,
    };
  }
}
