
import 'package:dio/dio.dart';

base class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic>? data;
  RefreshTokenResponse({
    this.data,
    required this.accessToken,
    required this.refreshToken,
  });

}

abstract interface class RefreshTokenManagerInterface {
  final String url;

  RefreshTokenManagerInterface(this.url);
  /// Makes a http call to the relative api to get refresh token. Returns [RefreshTokenResponse]
  /// This gets called by [AuthService] on expire of access-token.
  Future<RefreshTokenResponse> refreshToken({required String refreshToken});

  Future<bool> isExpiredTokenError({required DioException err});
}

