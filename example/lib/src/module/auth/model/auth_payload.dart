class AuthPayload {
  final String? accessToken;
  final String? refreshToken;
  final String? uid;
  final Map<String, dynamic> data;

  AuthPayload({
    required this.accessToken,
    required this.refreshToken,
    required this.data,
    this.uid,
  });

  factory AuthPayload.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AuthPayload(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      uid: json['uid'] as String? ?? json['user_id'] as String?,
      data: rawData is Map<String, dynamic>
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'uid': uid,
      'data': data,
    };
  }

  AuthPayload copyWith({
    String? accessToken,
    String? refreshToken,
    String? uid,
    Map<String, dynamic>? data,
  }) {
    return AuthPayload(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      uid: uid ?? this.uid,
      data: data ?? this.data,
    );
  }
}
