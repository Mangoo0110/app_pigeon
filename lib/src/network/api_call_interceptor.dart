part of '../../app_pigeon.dart';



class _CancelRefreshToken extends CancelToken {}

class ApiCallInterceptor extends Interceptor{
  
  ApiCallInterceptor(this._authStorage, this.dio, this.refreshTokenManager);

  final Dio dio;
  final Debugger _apiCallDebugger = ApiCallDebugger();
  final AuthStorage _authStorage;
  final RefreshTokenManagerInterface refreshTokenManager;
  bool _refreshingToken = false;
  final Queue<RequestOptions> _requestQueue = Queue<RequestOptions>();

  /// Attaches access token to every request
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _apiCallDebugger.dekhao("${options.uri.toString()} ${options.method}");
    final auth = await _authStorage.getCurrentAuth();
    final accessToken = auth?._accessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }
  
  /// Catch errors like 401 and retry with new access token if access token expires.
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // IF TIMEOUT, then possibly internet is down. Hence reject the request.
    final status = (await _authStorage.currentAuthStatus());
    if(err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.receiveTimeout) {
      _apiCallDebugger.dekhao("Timeout error");
      return handler.reject(err);
    }
    if(_refreshingToken) {
      _apiCallDebugger.dekhao("Already refreshing token");
      return handler.reject(err);
    }
    
    if(err.requestOptions.cancelToken != null) {
      return handler.reject(err);
    }

    if (err.response?.statusCode == 401 && (status is Authenticated)) {
      // get new access token
      RefreshTokenResponse refreshTokenResponse;
      try {
        _refreshingToken = true;
        refreshTokenResponse = await refreshTokenManager.refreshToken(
          refreshToken: status.auth._refreshToken ?? ""
        );
        _refreshingToken = false;
        await _authStorage.updateCurrentAuth(
          UpdateAuthParams(
            accessToken: refreshTokenResponse.accessToken,
            refreshToken: refreshTokenResponse.refreshToken,
            data: refreshTokenResponse.data
          )
        );
        // Waits a second to receive changes from secure storage.
        await Future.delayed(Duration(seconds: 1)).then((_) async{
          final RequestOptions requestOptions = err.requestOptions;

          try {
            final cloneReq = await dio.request(
              requestOptions.path,
              options: Options(
                method: requestOptions.method,
                contentType: requestOptions.contentType,
              ),
              cancelToken: _CancelRefreshToken(),
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );
            return handler.resolve(cloneReq);
          } catch (e) {
            return handler.reject(e as DioException);
          }
        });
      } catch (e) {
        // Failed to get
        _authStorage.clearCurrentAuthRecord();
        _refreshingToken = false;
        return handler.reject(e as DioException);
      }
    } else {
      _apiCallDebugger.dekhao("Error debug from dio interceptor: ${err.response?.data}");
      _apiCallDebugger.dekhao(err.message);
      return handler.next(err);
    }
    
  }
}