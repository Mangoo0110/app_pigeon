part of 'debug_service.dart';


class Debugger {
  final DebugLabel debugLabel;

  Debugger({required this.debugLabel});

  void dekhao(dynamic data) {
    DebugService.instance(allowsOnly: {debugLabel}).dekhao(debugLabel, data);
  }
}

class ServiceDebugger extends Debugger {
  ServiceDebugger() : super(debugLabel: DebugLabel.service);
}

class AuthDebugger extends Debugger {
  AuthDebugger() : super(debugLabel: DebugLabel.auth);
}

class NotificationDebugger extends Debugger {
  NotificationDebugger() : super(debugLabel: DebugLabel.notification);
}

class AudioDebugger extends Debugger {
  AudioDebugger() : super(debugLabel: DebugLabel.audio);
}


class UIDebugger extends Debugger {
  UIDebugger() : super(debugLabel: DebugLabel.ui);
}


class ControllerDebugger extends Debugger {
  ControllerDebugger() : super(debugLabel: DebugLabel.controller);
}
