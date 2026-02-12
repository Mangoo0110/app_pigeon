import 'package:example/src/core/api_handler/api_response.dart';

import '../../api_handler/api_handler.dart';
import '../../component/reactive_notifier/process_notifier.dart';
import '../../component/reactive_notifier/snackbar_notifier.dart';
import '../debug/debug_service.dart';


 Future<T?> handleFutureRequest<T>({
    required FutureRequest<T> Function() futureRequest,
    Debugger? debugger,
    ProcessStatusNotifier? processStatusNotifier,
    SnackbarNotifier? errorSnackbarNotifier,
    SnackbarNotifier? successSnackbarNotifier,
    void Function(T data)? onSuccess,
    void Function(DataCRUDFailure failure)? onError,
  }) async{
    processStatusNotifier?.setLoading();
    final res = await futureRequest();
    if(res is SuccessResponse) {
      processStatusNotifier?.setSuccess(
        message: (res as Success).message
      );
      successSnackbarNotifier?.notifySuccess(
        message: (res as Success).message
      );
      if(onSuccess != null && res.data is T) onSuccess(res.data as T);
      debugger?.dekhao("Success:: ${(res as Success).message}");
      return res.data;
    } else {
      processStatusNotifier?.setEnabled();
      errorSnackbarNotifier?.notifyError(message: (res as DataCRUDFailure).uiMessage);
      if(onError != null) onError(res as DataCRUDFailure);
      debugger?.dekhao("Error:: ${(res as DataCRUDFailure).uiMessage}");
      return null;
    }
  }
    