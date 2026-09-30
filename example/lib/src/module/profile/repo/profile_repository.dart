import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';

import '../model/profile/profile.dart';
import '../model/update_profile_request/update_profile_request.dart';

abstract class ProfileRepository with ErrorHandler {
  AsyncRequest<Profile> fetchProfile();
  AsyncRequest<void> updateProfile(UpdateProfileRequest request);
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
  AsyncRequest<Profile> fetchProfile() {
    return Future<ApiResponse<Profile>>.value(_notImplemented('Fetch profile'));
  }

  @override
  AsyncRequest<void> updateProfile(UpdateProfileRequest request) {
    return Future<ApiResponse<void>>.value(_notImplemented('Update profile'));
  }
}
