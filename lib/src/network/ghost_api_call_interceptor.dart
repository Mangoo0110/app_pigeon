part of '../ghost_pigeon.dart';

class GhostApiCallInterceptor extends Interceptor {
  GhostApiCallInterceptor();

  String? _token;

  /// Sets token. Attach to all next request's authorization header.
  set token(String? token) {
    _debugger.dekhao("Setting token: $token");
    _token = token;
  }

  final Debugger _debugger = ApiCallDebugger();

  /// Attaches access token to every request, if the [_token] is not null.
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _debugger
        .dekhao("Request API(${options.method}): ${options.uri.toString()}");
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final apiName = '${requestOptions.method} ${requestOptions.path}';
    _debugger.dekhao('Request failed($apiName): ${err.type.name}');
    return handler.next(err);
  }
}
