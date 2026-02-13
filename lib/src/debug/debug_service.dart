import 'package:flutter/foundation.dart';
part 'debugger.dart';

enum DebugLabel {
  ui("UI"),
  controller("Controller"),
  pigeonService("PigeonService"),
  authStorage("AuthStorage"),
  apiCall("ApiCall"),
  socketService("SocketService"); 

  final String label;

  const DebugLabel(this.label);
}


class DebugService {
  final Set<DebugLabel> _allowOnly;

  DebugService._(this._allowOnly);

  static DebugService? _instance;
  /// Singletone
  factory DebugService.instance({required Set<DebugLabel> allowsOnly}) {

    _instance ??= DebugService._(allowsOnly);
    return _instance!;
  }

  void dekhao(DebugLabel label, dynamic data) {
    if(!_allowOnly.contains(label)) return; 
    // Print, only if the debug label is present in the _allowOnly list.
    if(kDebugMode) {
      print("Debug >> ${label.label} >> ${data.toString()}");
    }
  }
}

