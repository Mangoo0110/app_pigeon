class ForgetPasswordRequest {
  final String email;

  ForgetPasswordRequest({required this.email});

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordRequest(
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  ForgetPasswordRequest copyWith({String? email}) {
    return ForgetPasswordRequest(
      email: email ?? this.email,
    );
  }
}
