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
    final dataMap =
        rawData is Map<String, dynamic>
              ? Map<String, dynamic>.from(rawData)
              : Map<String, dynamic>.from(json)
          ..remove('access_token')
          ..remove('accessToken')
          ..remove('refresh_token')
          ..remove('refreshToken')
          ..remove('uid')
          ..remove('user_id')
          ..remove('userId');
    return AuthPayload(
      accessToken: (json['access_token'] ?? json['accessToken']) as String?,
      refreshToken: (json['refresh_token'] ?? json['refreshToken']) as String?,
      uid: (json['uid'] ?? json['user_id'] ?? json['userId']) as String?,
      data: dataMap,
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
