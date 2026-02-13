mixin class PigeonErrorHandler {
  Future<T?> runGuarded<T>(
    Future<T> Function() action, {
    void Function(Object error, StackTrace stack)? onError,
    bool rethrowError = false,
  }) async {
    try {
      return await action();
    } catch (e, stack) {
      if (onError != null) {
        onError(e, stack);
      }

      if (rethrowError) {
        rethrow;
      }

      return null;
    }
  }
}

