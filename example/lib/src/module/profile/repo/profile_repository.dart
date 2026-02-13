import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';

abstract class ProfileRepository with ErrorHandler {
  AsyncRequest<Map<String, dynamic>> fetchProfile();
  AsyncRequest<void> updateProfile({required String fullName});
}

class ProfileRepositoryStub extends ProfileRepository {
  ApiResponse<T> _notImplemented<T>(String feature) {
    return ErrorResponse(
      message: '$feature is not implemented yet.',
      exception: Exception('Not implemented'),
      stackTrace: StackTrace.current,
    );
  }

  @override
  AsyncRequest<Map<String, dynamic>> fetchProfile() {
    return Future<ApiResponse<Map<String, dynamic>>>.value(
      _notImplemented('Fetch profile'),
    );
  }

  @override
  AsyncRequest<void> updateProfile({required String fullName}) {
    return Future<ApiResponse<void>>.value(_notImplemented('Update profile'));
  }
}
