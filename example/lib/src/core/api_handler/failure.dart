enum Failure {
  dioFailure,
  socketFailure,
  authFailure,
  severFailure,
  firebaseFailure,
  requiresRecentLogin,
  unknownFailure,
  outOfMemoryError,
  noData,
  timeout,
  forbidden,
}

class DataCRUDFailure {
  final Failure failure;
  /// Message to be shown to the user
  /// Defaults to `fullError`
  final String uiMessage;
  final String fullError;
  final StackTrace? stackTrace;

  DataCRUDFailure({required this.failure, String? uiMessage, required this.fullError, this.stackTrace}):uiMessage = uiMessage ?? fullError;

  @override
  String toString() {
    return 'DataCRUDFailure(failure: ${failure.name}, message: $fullError, stackTrace: $stackTrace)';
  }
}