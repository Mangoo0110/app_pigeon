part of 'debug_service.dart';


class Debugger {
  final DebugLabel debugLabel;

  Debugger({required this.debugLabel});

  void dekhao(dynamic data) {
    DebugService.instance(allowsOnly: {debugLabel}).dekhao(debugLabel, data);
  }
}

class AuthServiceDebugger extends Debugger {
  AuthServiceDebugger() : super(debugLabel: DebugLabel.authService);
}

class AuthStorageDebugger extends Debugger {
  AuthStorageDebugger() : super(debugLabel: DebugLabel.authStorage);
}

class ApiCallDebugger extends Debugger {
  ApiCallDebugger() : super(debugLabel: DebugLabel.apiCall);
}

class SocketServiceDebugger extends Debugger {
  SocketServiceDebugger() : super(debugLabel: DebugLabel.socketService);
}

class UIDebugger extends Debugger {
  UIDebugger() : super(debugLabel: DebugLabel.ui);
}

class ControllerDebugger extends Debugger {
  ControllerDebugger() : super(debugLabel: DebugLabel.controller);
}
