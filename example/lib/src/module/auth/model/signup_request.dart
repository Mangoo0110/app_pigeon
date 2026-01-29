class SignupRequest {
  final String email;
  final String password;
  final String fullName;

  SignupRequest({
    required this.email,
    required this.password,
    required this.fullName,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) {
    return SignupRequest(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
    };
  }

  SignupRequest copyWith({
    String? email,
    String? password,
    String? fullName,
  }) {
    return SignupRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
    );
  }
}
