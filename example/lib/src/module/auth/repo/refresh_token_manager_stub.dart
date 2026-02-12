import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/constants/api_endpoints.dart';
import 'package:flutter/widgets.dart';

class MyRefreshTokenManager implements RefreshTokenManagerInterface {
  @override
  final String url;

  MyRefreshTokenManager():url = ApiEndpoints.refreshToken;

  @override
  Future<RefreshTokenResponse> refreshToken({
    required String refreshToken,
    required Dio dio,
  }) async {
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
    );
  }
}
