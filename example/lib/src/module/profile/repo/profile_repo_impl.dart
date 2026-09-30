import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/core/constants/api_endpoints.dart';

import '../model/profile/profile.dart';
import '../model/update_profile_request/update_profile_request.dart';
import 'profile_repository.dart';

class ProfileRepoImpl extends ProfileRepository {
  ProfileRepoImpl(this.appPigeon);

  final AppPigeon appPigeon;

  @override
  AsyncRequest<Profile> fetchProfile() {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.userProfile);
        final data = extractBodyData(response);
        final profile = data is Map<String, dynamic>
            ? Profile.fromJson(data)
            : Profile.empty;
        return SuccessResponse<Profile>(
          data: profile,
          message: 'Profile loaded.',
        );
      },
    );
  }

  @override
  AsyncRequest<void> updateProfile(UpdateProfileRequest request) {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.patch(ApiEndpoints.userProfile, data: request.toJson());
        return SuccessResponse<void>(data: null, message: 'Profile updated.');
      },
    );
  }
}
