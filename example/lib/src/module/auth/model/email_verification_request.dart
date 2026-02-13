class EmailVerificationRequest {
  final String userId;
  final String verificationCode;

  EmailVerificationRequest({
    required this.userId,
    required this.verificationCode,
  });

  factory EmailVerificationRequest.fromJson(Map<String, dynamic> json) {
    return EmailVerificationRequest(
      userId: json['user_id'] as String? ?? '',
      verificationCode: json['verification_code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'verification_code': verificationCode,
    };
  }

  EmailVerificationRequest copyWith({
    String? userId,
    String? verificationCode,
  }) {
    return EmailVerificationRequest(
      userId: userId ?? this.userId,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}
