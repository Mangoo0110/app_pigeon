import 'package:dio/dio.dart';

import 'debug/debug_service.dart';
import 'error_handler/pigeon_error_handler.dart';
import 'interface/app_pigeon.dart';
import 'params/socket_connect_param.dart';
import 'socket/socket_service.dart';

part 'network/ghost_api_call_interceptor.dart';

class GhostAppPigeon with PigeonErrorHandler implements AppPigeon {
  GhostAppPigeon({
    int connectTimeout = 15000,
    int receiveTimeout = 15000,
    required this.baseUrl,
    this.onError,
    this.allowOnly = const {
      DebugLabel.apiCall,
      DebugLabel.pigeonService,
      DebugLabel.socketService,
    },
  }) {
    _init(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      onError: onError,
    );
  }

  final Debugger _debugger = PigeonServiceDebugger();
  final Dio _dio = Dio();
  final Set<DebugLabel> allowOnly;
  final SocketService _socketService = SocketService();
  late final GhostApiCallInterceptor _apiCallInterceptor;
  final String baseUrl;
  final Function(Object e, StackTrace stacktrace)? onError;

  Future<void> _init({
    required int connectTimeout,
    required int receiveTimeout,
    void Function(Object error, StackTrace stack)? onError,
  }) async {
    await runGuarded(
      () async {
        _debugger.dekhao('Initializing GhostAppPigeon');
        _dio.options.baseUrl = baseUrl;
        _dio.options.connectTimeout = Duration(milliseconds: connectTimeout);
        _dio.options.receiveTimeout = Duration(milliseconds: receiveTimeout);
        _apiCallInterceptor = GhostApiCallInterceptor();
        _dio.interceptors.add(_apiCallInterceptor);
      },
      onError: onError,
      rethrowError: false,
    );
  }

  void setAuthToken(String? token) {
    _apiCallInterceptor.token = token;
  }

  @override
  void dispose() {
    _socketService.dispose();
  }

  /// Disconnects ghost socket listeners/connection.
  void disconnectSocket() {
    _socketService.dispose();
  }

  @override
  Future<Response> get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post(
      path,
      data: data,
      options: options,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response> put(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put(
      path,
      data: data,
      options: options,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response> patch(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.patch(
      path,
      data: data,
      options: options,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response> delete(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.delete(
      path,
      data: data,
      options: options,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<void> socketInit(SocketConnetParamX param) async {
    _socketService.init(
      SocketConnectParam(
        url: param.socketUrl,
        token: param.token,
        joinId: param.joinId,
      ),
    );
  }

  @override
  Stream<dynamic> listen(String channelName) {
    return _socketService.listen(channelName);
  }

  @override
  void emit(String eventName, [dynamic data]) {
    _socketService.emit(eventName, data);
  }
}
