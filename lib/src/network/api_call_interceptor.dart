part of '../app_pigeon.dart';

class _PendingRequest {
  _PendingRequest({
    required this.requestOptions,
    required this.completer,
  });

  final RequestOptions requestOptions;
  final Completer<Response<dynamic>> completer;
}

class ApiCallInterceptor extends Interceptor{
  
  ApiCallInterceptor(this._authStorage, this.dio, this.refreshTokenManager);

  final Dio dio;
  final Debugger _debugger = ApiCallDebugger();
  final AuthStorageInterface _authStorage;
  final RefreshTokenManagerInterface refreshTokenManager;
  static const String _refreshRetriedKey = '_refreshRetried';
  // Holds 401-failed requests while a token refresh is in progress.
  final List<_PendingRequest> _pendingRequests = <_PendingRequest>[];
  // Ensures only one refresh request runs at a time.
  bool _isRefreshing = false;

  /// Attaches access token to every request
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _debugger.dekhao("Request API(${options.method}): ${options.uri.toString()}");
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
    final requestOptions = err.requestOptions;
    final apiName = '${requestOptions.method} ${requestOptions.path}';
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.cancel) {
      _debugger.dekhao('Request failed($apiName): ${err.type.name}');
      return handler.reject(err);
    }

    final status = await _authStorage.currentAuthStatus();
    final alreadyRetried = requestOptions.extra[_refreshRetriedKey] == true;
    if(alreadyRetried) {
      _debugger.dekhao('Already retried for $apiName. Not retrying again.');
      return handler.reject(err);
    }
    final shouldRefresh = status is Authenticated &&
        !alreadyRetried &&
        await refreshTokenManager.shouldRefresh(err, handler);

    if (shouldRefresh) {
      final refreshToken = status.auth._refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        _debugger.dekhao('No refresh token available. Rejecting $apiName');
        await _authStorage.clearCurrentAuthRecord();
        _pendingRequests.clear();
        return handler.reject(err);
      }

      // Queue this request and resolve/reject it after refresh completes.
      _debugger.dekhao('401 received for $apiName. Queuing request for refresh.');
      final completer = Completer<Response<dynamic>>();
      _pendingRequests.add(
        _PendingRequest(
          requestOptions: requestOptions,
          completer: completer,
        ),
      );
      _debugger.dekhao('Pending queue size: ${_pendingRequests.length}');

      if (!_isRefreshing) {
        // Start refresh cycle once; remaining 401s only enqueue.
        unawaited(_refreshAndFlushQueue(refreshToken, requestOptions));
      }

      try {
        final response = await completer.future;
        return handler.resolve(response);
      } catch (e) {
        final dioError = e is DioException
            ? e
            : DioException(requestOptions: requestOptions, error: e);
        return handler.reject(dioError);
      }
    }

    _debugger.dekhao("Error debug from dio interceptor: ${err.response?.data}");
    _debugger.dekhao('Request failed($apiName): ${err.message}');

    return handler.next(err);
  }

  Future<void> _refreshAndFlushQueue(
    String refreshToken,
    RequestOptions sourceRequest,
  ) async {
    _isRefreshing = true;
    _debugger.dekhao('Starting refresh token call.');
    try {
      // Use a clean Dio instance for refresh call to avoid interceptor recursion.
      final refreshTokenResponse = await refreshTokenManager.refreshToken(
        refreshToken: refreshToken,
        dio: Dio(
          BaseOptions(
            baseUrl: sourceRequest.baseUrl,
            connectTimeout: sourceRequest.connectTimeout,
            receiveTimeout: sourceRequest.receiveTimeout,
          ),
        ),
      );
      await _authStorage.updateCurrentAuth(
        UpdateAuthParams(
          accessToken: refreshTokenResponse.accessToken,
          refreshToken: refreshTokenResponse.refreshToken,
          data: refreshTokenResponse.data,
        ),
      );
      _debugger.dekhao(
        // Replay queued calls after auth storage gets new tokens.
        'Refresh succeeded. Flushing ${_pendingRequests.length} queued requests.',
      );
      await _flushPendingRequests();
    } catch (e, s) {
      // Refresh failed: force unauthenticated state and fail all queued requests.
      _debugger.dekhao('Refresh failed. Rejecting queued requests: $e');
      debugPrint(e.toString());
      debugPrint(s.toString());
      await _authStorage.clearCurrentAuthRecord();
      _rejectPendingRequests(e);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _flushPendingRequests() async {
    final queued = List<_PendingRequest>.from(_pendingRequests);
    _pendingRequests.clear();

    for (final pending in queued) {
      final apiName =
          '${pending.requestOptions.method} ${pending.requestOptions.path}';

      if (pending.requestOptions.cancelToken?.isCancelled == true) {
        // Request was cancelled by caller while waiting in queue.
        pending.completer.completeError(
          DioException(
            requestOptions: pending.requestOptions,
            type: DioExceptionType.cancel,
            error: 'Request cancelled while waiting for token refresh.',
          ),
        );
        _debugger.dekhao('Skipped cancelled queued request: $apiName');
        continue;
      }

      try {
        final response = await _retryRequest(pending.requestOptions);
        pending.completer.complete(response);
        _debugger.dekhao('Queued request retry succeeded: $apiName');
      } catch (e) {
        pending.completer.completeError(e);
        _debugger.dekhao('Queued request retry failed: $apiName, error: $e');
      }
    }
  }

  void _rejectPendingRequests(Object error) {
    final queued = List<_PendingRequest>.from(_pendingRequests);
    _pendingRequests.clear();
    // Fan-out refresh failure to every queued request.
    for (final pending in queued) {
      pending.completer.completeError(error);
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) {
    _debugger.dekhao(
      'Retrying request: ${requestOptions.method} ${requestOptions.path}',
    );
    final nextExtra = Map<String, dynamic>.from(requestOptions.extra)
      ..[_refreshRetriedKey] = true;

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      options: Options(
        method: requestOptions.method,
        headers: Map<String, dynamic>.from(requestOptions.headers),
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        validateStatus: requestOptions.validateStatus,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: nextExtra,
      ),
    );
  }
}
