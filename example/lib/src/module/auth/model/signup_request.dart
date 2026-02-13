class SignupRequest {
  final String email;
  final String password;
  final String userName;

  SignupRequest({
    required this.email,
    required this.password,
    required this.userName,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) {
    return SignupRequest(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'userName': userName};
  }

  SignupRequest copyWith({String? email, String? password, String? userName}) {
    return SignupRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
    );
  }

  @override
  String toString() {
    return 'SignupRequest(email: $email, password: $password, userName: $userName)';
  }
}
