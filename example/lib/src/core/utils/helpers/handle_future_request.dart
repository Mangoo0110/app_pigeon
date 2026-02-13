import 'package:example/src/core/api_handler/api_response.dart';
import 'package:flutter/widgets.dart';

import '../../api_handler/api_handler.dart';
import '../../component/reactive_notifier/process_notifier.dart';
import '../../component/reactive_notifier/snackbar_notifier.dart';
import '../debug/debug_service.dart';

Future<T?> handleFutureRequest<T>({
  required AsyncRequest<T> Function() futureRequest,
  Debugger? debugger,
  ProcessStatusNotifier? processStatusNotifier,
  SnackbarNotifier? errorSnackbarNotifier,
  SnackbarNotifier? successSnackbarNotifier,
  void Function(T data)? onSuccess,
  VoidCallback? onSuccessWithoutData,
  void Function(ErrorResponse failure)? onError,
}) async {
  processStatusNotifier?.setLoading();
  final res = await futureRequest();
  debugPrint("Response: ${res.toString()}");
  if (res is SuccessResponse) {
    processStatusNotifier?.setSuccess(
      message: (res as SuccessResponse).message,
    );
    successSnackbarNotifier?.notifySuccess(
      message: (res as SuccessResponse).message,
    );
    if (onSuccessWithoutData != null) onSuccessWithoutData();
    if (onSuccess != null && res.data is T) onSuccess(res.data as T);
    debugger?.dekhao("Success:: ${(res as SuccessResponse).message}");
    return res.data;
  } else {
    processStatusNotifier?.setEnabled();
    errorSnackbarNotifier?.notifyError(message: (res as ErrorResponse).message);
    if (onError != null) onError(res as ErrorResponse);
    debugger?.dekhao("Error:: ${(res as ErrorResponse).exception}");
    debugger?.dekhao("Stacktrace:: ${(res as ErrorResponse).stackTrace}");
    return null;
  }
}
