abstract class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, required this.data});

  @override
  String toString() {
    return '''ApiResponse{success: $success, ${"\n"}message: $message, ${"\n"}data: $data${"\n"}}''';
  }
}

class SuccessResponse<T> extends ApiResponse<T> {
  SuccessResponse({super.message = "Success!", required super.data}): super(success: true);
}

class ErrorResponse<T> extends ApiResponse<T> {
  final Exception exception;
  final StackTrace stackTrace;
  ErrorResponse({
    super.message = "Error!",
    super.data,
    required this.exception,
    required this.stackTrace,
  }) : super(success: false);

  @override
  String toString() {
    return '''ErrorResponse{message: $message,${"\n"}data: $data, ${"\n"}exception: $exception, ${"\n"}stackTrace: $stackTrace${"\n"}}''';
  }
}