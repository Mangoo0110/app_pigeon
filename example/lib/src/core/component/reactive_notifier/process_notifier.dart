import 'package:flutter/material.dart';

sealed class ProcessStatus {
  String message;
  ProcessStatus({this.message = ""});
}

class ProcessEnabled extends ProcessStatus {
  ProcessEnabled({String? message })
      : super(message: message ?? "Enabled");
}

class ProcessDisabled extends ProcessStatus {
  ProcessDisabled({String? message })
      : super(message: message ?? "Disabled");
}

class ProcessLoading extends ProcessStatus {
  ProcessLoading({String? message })
      : super(message: message ?? "Loading");
}

class ProcessFailed extends ProcessStatus {
  ProcessFailed({String? message })
      : super(message: message ?? "Error");
}

class ProcessSuccess extends ProcessStatus {
  ProcessSuccess({String? message })
      : super(message: message ?? "Success");
}

/// An observable ChangeNotifier that manages the status of a process, such as loading, success, error, enabled, and disabled.
///
/// Usage:
/// ```dart
/// // Create an instance of ProcessStatusNotifier
/// final processNotifier = ProcessStatusNotifier();
///
/// // Set the status to loading
/// processNotifier.setLoading(message: "Loading data...");
/// // Set the status to success
/// processNotifier.setSuccess(message: "Data loaded successfully!");
/// // Set the status to error
/// processNotifier.setError(message: "Failed to load data.");
/// // Set the status to enabled
/// processNotifier.setEnabled(message: "Ready to proceed.");
/// // Set the status to disabled
/// processNotifier.setDisabled(message: "Action not available.");
/// ```
/// 
/// This class is build to be used with widgets that need to reflect process states visually.
/// Normally, buttons that trigger async operations has to reflect the 
/// ### idle/disabled, enabled, loading, success, error states.
/// 
/// Widgets like [RProcessNotifierButton] and [RIcon] both utilize this notifier to reflect process states visually.
class ProcessStatusNotifier extends ChangeNotifier{

  /// By default the button status is set to DisabledStatus.
  /// If you want to set the initial button status to a different status, pass it in the constructor
  ProcessStatusNotifier({ProcessStatus? initialStatus}) {
    _status = initialStatus ?? ProcessDisabled();
  }
  ProcessStatus _status = ProcessDisabled();
  ProcessStatus get status => _status;

  void setLoading({String? message}) {
    _status = ProcessLoading(message: message);
    notifyListeners();
  }
  setSuccess({String? message}) {
    _status = ProcessSuccess(message: message);
    notifyListeners();
  }
  setError({String? message}) {
    _status = ProcessFailed(message: message);
    notifyListeners();
  }
  setEnabled({String? message}) {
    if(_status is ProcessEnabled) return;
    _status = ProcessEnabled(message: message);
    notifyListeners();
  }
  setDisabled({String? message}) {
    _status = ProcessDisabled(message: message);
    notifyListeners();
  }

  void reset(String? message) {
    _status = ProcessEnabled(message: message);
    notifyListeners();
  }
}