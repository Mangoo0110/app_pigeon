part of '../app_pigeon.dart';

enum SocketRequestType {
  connect, emit, disconnect;

  static SocketRequestType? fromString(String value) {
    switch (value) {
      case 'connect':
        return SocketRequestType.connect;
      case 'emit':
        return SocketRequestType.emit;
      case 'disconnect':
        return SocketRequestType.disconnect;
      default:
        return null;
    }
  }
}

abstract base class SocketRequest {
  final SocketRequestType type;

  SocketRequest(this.type);
  Map<String, dynamic> toMap();
}

final class SocketConnectRequest extends SocketRequest{
  final String url;
  final String token;
  final String userId;

  SocketConnectRequest({required this.url, required this.token, required this.userId}): super(SocketRequestType.connect);

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'url': url,
      'token': token,
      'userId': userId,
    };
  }

}

final class SocketEmitRequest extends SocketRequest {
  final String event;
  final dynamic data;

  SocketEmitRequest({required this.event, required this.data}): super(SocketRequestType.emit);
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'event': event,
      'data': data,
    };
  }
}

final class SocketDisconnectRequest extends SocketRequest {
  SocketDisconnectRequest(): super(SocketRequestType.disconnect);
  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
    };
  }
}