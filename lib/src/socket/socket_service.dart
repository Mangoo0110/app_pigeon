import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../debug/debug_service.dart';

class SocketConnectParam {
  final String? token;
  final String joinId;
  final String url;

  SocketConnectParam({
    required this.token,
    required this.joinId,
    required this.url,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SocketConnectParam &&
        other.token == token &&
        other.joinId == joinId &&
        other.url == url;
  }

  @override
  int get hashCode => Object.hash(token, joinId, url);
}

class SocketService {
  final Map<String, StreamController<dynamic>> _events = {};
  io.Socket? _socket;
  final Debugger _debugger = SocketServiceDebugger();

  SocketConnectParam? _param;

  bool get isConnected => _socket?.connected ?? false;

  void init(SocketConnectParam socketConnectParam, {bool force = false}) {
    if (_param == socketConnectParam && !force) {
      return;
    }
    _param = socketConnectParam;
    _disposeSocket();
    _init();
  }

  Future<void> _init() async {
    if (_param == null) {
      return;
    }
    final token = _param!.token;
    final options = io.OptionBuilder().setTransports(['websocket']);
    if (token != null && token.isNotEmpty) {
      options.setExtraHeaders({'Authorization': 'Bearer $token'});
    }

    _socket = io.io(_param!.url, options.build());
    _socket?.connect();
    _socket?.onConnect((_) {
      _debugger.dekhao('Socket connected');
    });
  }

  void emit(String eventName, [dynamic data]) {
    _init().then((_) {
      _socket?.emit(eventName, data);
    });
  }

  Stream<dynamic> listen(String eventName) {
    _debugger.dekhao('Listening to $eventName');
    if (_events.containsKey(eventName)) {
      return _events[eventName]!.stream;
    }

    final controller = StreamController<dynamic>.broadcast();
    _events[eventName] = controller;

    _init().then((_) {
      _socket?.on(eventName, (data) {
        controller.add(data);
      });
    });

    return controller.stream;
  }

  void stopListeningForEvent(String eventName) {
    _socket?.off(eventName);
    _events[eventName]?.close();
    _events.remove(eventName);
  }

  void dispose() {
    _disposeSocket();
  }

  void _disposeSocket() {
    for (final controller in _events.values) {
      controller.close();
    }
    _events.clear();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }
}
