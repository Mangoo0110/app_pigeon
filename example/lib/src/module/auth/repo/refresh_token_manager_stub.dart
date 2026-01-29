import 'package:app_pigeon/app_pigeon.dart';

class RefreshTokenManagerStub implements RefreshTokenManagerInterface {
  @override
  final String url;

  RefreshTokenManagerStub({this.url = '/auth/refresh'});

  @override
  Future<RefreshTokenResponse> refreshToken({
    required String refreshToken,
    required Dio dio,
  }) async {
    throw UnimplementedError('Refresh token API is not implemented yet.');
  }
}
