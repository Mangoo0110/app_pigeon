import 'dart:async';
import 'dart:convert';
import 'package:app_pigeon/src/auth/interface/auth_storage_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'auth/interface/current_auth_uid_manager_interface.dart';
import 'debug/debug_service.dart';
import 'params/socket_connect_param.dart';
import 'refresh_token_manager.dart';
part 'auth/auth.dart';
part 'auth/auth_status.dart';
part 'auth/auth_storage.dart';
part 'socket/socket_service.dart';
part 'params/auth_params.dart';
part 'network/api_call_interceptor.dart';

mixin class _ErrorHandler {
  Future<T?> runGuarded<T>(
    Future<T> Function() action, {
    void Function(Object error, StackTrace stack)? onError,
    bool rethrowError = false,
  }) async {
    try {
      return await action();
    } catch (e, stack) {
      if (onError != null) {
        onError(e, stack);
      }

      if (rethrowError) {
        rethrow;
      }

      return null;
    }
  }
}



class AppPigeon with _ErrorHandler {
  AppPigeon(
    this.refreshTokenManager, {
    int connectTimeout = 15000, // milliseconds
    int receiveTimeout = 15000, // milliseconds
    required this.baseUrl,
    this.onError,
    this.allowOnly = const {
      DebugLabel.apiCall,
      DebugLabel.authService,
      DebugLabel.authStorage,
      DebugLabel.socketService
    },
  }) {
    // Set base url
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = Duration(milliseconds: connectTimeout);
    _dio.options.receiveTimeout = Duration(milliseconds: receiveTimeout);
    // Initialize and add interceptor
    _apiCallInterceptor = ApiCallInterceptor(_authStorage, _dio, refreshTokenManager);
    _dio.interceptors.add(_apiCallInterceptor);
    _init(connectTimeout: connectTimeout, receiveTimeout: receiveTimeout, onError: onError);
  }

  final Dio _dio = Dio();
  final Set<DebugLabel> allowOnly;
  final SocketService _socketService = SocketService();
  late final AuthStorageInterface _authStorage = AuthStorage();
  final RefreshTokenManagerInterface refreshTokenManager;
  late final ApiCallInterceptor _apiCallInterceptor;
  final String baseUrl;
  final Function(Object e, StackTrace stacktrace)? onError;

  Future<void> _init({
    required int connectTimeout,
    required int receiveTimeout,
    void Function(Object error, StackTrace stack)? onError,
  }) async {
    await runGuarded(
      () async {
        debugPrint("Initializing AppPigeon");
        
        // Initialize auth storage
        debugPrint("Calling init() on AuthStorage");
        _authStorage.init();
      },
      onError: onError,
      rethrowError: false,
    );
  }
  

  dispose() {
    _authStorage.dispose();
    _socketService._disposeSocket();
  }

  Stream<AuthStatus> get authStream => _authStorage.authStream;

  Future<void> saveNewAuth({required SaveNewAuthParams saveAuthParams}) async {
    await _authStorage.saveNewAuth(saveAuthParams);
  }

  Future<void> updateCurrentAuth({
    required UpdateAuthParams updateAuthParams,
  }) async {
    await _authStorage.updateCurrentAuth(updateAuthParams);
  }

  /// Returns the current auth record stored.
  Future<Auth?> getCurrentAuthRecord() async {
    return await _authStorage.getCurrentAuth();
  }

  /// Returns all saved separate auth records that are stored locally.
  Future<List<Auth>> getAllAuthRecords() async {
    return await _authStorage.getAllAuth();
  }

  /// This will remove the current auth reference and data stored locally.
  Future<void> logOut() async {
    await _authStorage.clearCurrentAuthRecord();
  }

  /// Switches current auth by uid.
  Future<void> switchAccount({required String uid}) async {
    await _authStorage.switchAccount(uid: uid);
  }

  // Public GET/POST/PUT/DELETE [DIO] wrappers

  /// ### GET
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

  /// ### POST
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

  /// ### PUT
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

  /// ### PATCH
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

  /// ### DELETE
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
        (await _authStorage.getCurrentAuth())?._accessToken;
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
