part of '../app_pigeon.dart';

class SocketConnectParam {
  final String _token;
  final String _joinId;
  final String url;

  SocketConnectParam({
    required String token,
    required String joinId,
    required this.url
  }) : 
       _token = token,
       _joinId = joinId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocketConnectParam &&
        other._token == _token &&
        other._joinId == _joinId &&
        other.url == url;
  }
  
  @override
  int get hashCode => Object.hash(_token, _joinId, url);
}

sealed class NetworkStatus {
  const NetworkStatus();
}

final class NetworkConnected extends NetworkStatus {
  const NetworkConnected();
}

final class NetworkDisconnected extends NetworkStatus {
  const NetworkDisconnected();
}

class SocketService {
  final Map<String, StreamController<dynamic>> _events = {};
  io.Socket? _socket;
  final Debugger _debugger = AuthServiceDebugger();

  SocketService();
  // Socket connect param
  // Pass this param to the `init()` method to initialize the socket
  SocketConnectParam? _param;

  bool get isConnected => _socket?.connected ?? false;
  /// This api will initialize the socket connection with the given param
  /// 
  /// If a socket connection already exists, it will be disposed and a new connection will be created
  void init(SocketConnectParam socketConnectParam,{bool force = false}) {
    if(_param == socketConnectParam && !force) {
      return;
    }
     _param = socketConnectParam;
    // Dispose previous socket, if exists
    _disposeSocket();
    _init();
  }

  Future<void> _init() async {
    // if (_socket != null) {
    //   _debugger.dekhao("Socket already initialized. Not initializing again.");
    //   return;
    // }
    if(_param == null) {
      return;
    }
    final token = _param!._token; 
    _socket = io.io(
      _param!.url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );
    _socket?.connect();
    _socket?.onConnect((data) {
      _debugger.dekhao("Socket connected ${"\n\n"}");
    });
  }

  void emit(String eventName, dynamic data) {
    _init().then((_) {
      _socket?.emit(eventName, data);
    });
  }

  Stream<dynamic> listen(String eventName,) {
    _debugger.dekhao("Listening to $eventName");
    if (_events.containsKey(eventName)) {
      _debugger.dekhao("Already listening to $eventName");
      return _events[eventName]!.stream;
    }
    
    final controller = StreamController<dynamic>.broadcast();
    _events[eventName] = controller;

    _init().then((_) {
      _socket?.on(eventName, (data) {
        //_debugger.dekhao("Socket data: $data");
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

  void _disposeSocket() {
    _debugger.dekhao("Closing controllers and diposing socket...");
    for (var controller in _events.values) {
      controller.close();
    }
    _events.clear();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }
}

