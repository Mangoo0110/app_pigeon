import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'src/debug/debug_service.dart';
import 'src/params/socket_connect_param.dart';
import 'src/refresh_token_manager.dart';
part 'src/auth/auth_service.dart';
part 'src/auth/auth.dart';
part 'src/auth/auth_status.dart';
part 'src/auth/auth_storage.dart';
part 'src/socket/socket_service.dart';
part 'src/params/auth_params.dart';
part 'src/network/api_call_interceptor.dart';


class AppPigeon {
  AppPigeon(
    this._dio,
    this._secureStorage,
    this.refreshTokenManager, {
    required this.baseUrl,
    this.allowOnly = const {
      DebugLabel.apiCall,
      DebugLabel.authService,
      DebugLabel.authStorage,
      DebugLabel.socketService
    },
  }) {
    // Set base url
    _dio.options.baseUrl = baseUrl;
    // Initialize and add interceptor
    _dio.interceptors.add(_apiCallInterceptor);
    _authService = AuthService(_secureStorage, refreshTokenManager);
    _apiCallInterceptor = ApiCallInterceptor(_authService._authStorage, _dio, refreshTokenManager);
    _dio.interceptors.add(_apiCallInterceptor);
    _authService.init();
  }

  final Dio _dio;
  final Set<DebugLabel> allowOnly;
  final SocketService _socketService = SocketService();
  late final AuthService _authService;
  final FlutterSecureStorage _secureStorage;
  final RefreshTokenManagerInterface refreshTokenManager;
  late final ApiCallInterceptor _apiCallInterceptor;
  final String baseUrl;
  

  dispose() {
    _authService.dispose();
    _socketService._disposeSocket();
  }

  Stream<AuthStatus> get authStream => _authService.authStream;

  Future<void> saveNewAuth({required SaveNewAuthParams saveAuthParams}) async {
    await _authService.saveNewAuth(saveNewAuthParams: saveAuthParams);
  }

  Future<void> updateCurrentAuth({
    required UpdateAuthParams updateAuthParams,
  }) async {
    await _authService.updateCurrentAuth(updateAuthParams: updateAuthParams);
  }

  /// Returns the current auth record stored.
  Future<Auth?> getCurrentAuthRecord() async {
    return await _authService._authStorage.getCurrentAuth();
  }

  /// Returns all saved separate auth records that are stored locally.
  Future<List<Auth>> getAllAuthRecords() async {
    return await _authService._authStorage.getAllAuth();
  }

  /// This will remove the current auth reference and data stored locally.
  Future<void> logOut() async {
    await _authService.clearCurrentAuthRecord();
  }

  // Public GET/POST/PUT/DELETE [DIO] wrappers
  Future<Response> get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get(path,
        queryParameters: queryParameters,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response> post(String path, {
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

  Future<Response> put(String path, {
    dynamic data, 
    Options? options,  
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put(path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response> patch(String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.patch(path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.delete(path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken);
  }

  // Socket parts
  /// Initialize socket connection
  /// [param.token] is optional. If not provided, it will try to get the
  /// current auth token from the current auth record stored.
  /// If no current auth record is found, socket will not be initialized.
  /// 
  /// ### NOTE:: If you want to see debug logs from socket service,
  /// ### make sure to add [DebugLabel.socketService] to the [allowOnly] set, while setting up your [AppPigeon]
  Future<void> socketInit(SocketConnetParamX param) async {
    final token =
        param.token ??
        (await _authService._authStorage.getCurrentAuth())?._accessToken;
    if (token == null) {
      return;
    }
    final socketConnectParam = SocketConnectParam(
      url: param.socketUrl,
      token: token,
      joinId: param.joinId,
    );
    _socketService.init(socketConnectParam);
  }

  /// Listen to socket event
  Stream<dynamic> listen(String channelName) {
    return _socketService.listen(channelName);
  }

  /// Emit an event through socket;
  /// [data] is optional
  ///
  /// Usecases:::
  /// 1. Emitting a join event after socket connection
  /// 2. Emitting a chat message
  /// 3. Emitting a typing indicator
  /// ... etc
  void emit(String eventName, [dynamic data]) {
    _socketService.emit(eventName, data);
  }
}
