import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
  Future<RefreshTokenResponse> refreshToken(
      {required String refreshToken, required Dio dio});

  Future<bool> shouldRefresh(DioException err, ErrorInterceptorHandler handler);
}

class BasicRefreshTokenManager extends RefreshTokenManagerInterface {
  BasicRefreshTokenManager(super.url);

  @override
  Future<bool> shouldRefresh(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      return true;
    }
    return false;
  }

  @override
  Future<RefreshTokenResponse> refreshToken(
      {required String refreshToken, required Dio dio}) async {
    debugPrint("Refreshing token with $refreshToken");
    final res = await dio.post(
      url,
      data: {
        'refreshToken': refreshToken,
      },
    );

    debugPrint("Refresh token response: ${res.data}");

    debugPrint(res.data.toString());

    return RefreshTokenResponse(
      accessToken: res.data["data"]['accessToken'],
      refreshToken: res.data["data"]['refreshToken'],
      data: res.data["data"],
    );
  }
}
