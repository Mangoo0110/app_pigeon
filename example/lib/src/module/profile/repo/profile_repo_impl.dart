import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/core/constants/api_endpoints.dart';

import 'profile_repository.dart';

class ProfileRepoImpl extends ProfileRepository {
  ProfileRepoImpl(this.appPigeon);

  final AppPigeon appPigeon;

  @override
  AsyncRequest<Map<String, dynamic>> fetchProfile() {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.userProfile);
        final data = extractBodyData(response);
        final profile = data is Map<String, dynamic>
            ? Map<String, dynamic>.from(data)
            : <String, dynamic>{};
        return SuccessResponse<Map<String, dynamic>>(
          data: profile,
          message: 'Profile loaded.',
        );
      },
    );
  }

  @override
  AsyncRequest<void> updateProfile({required String fullName}) {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.patch(
          ApiEndpoints.userProfile,
          data: <String, dynamic>{'fullName': fullName},
        );
        return SuccessResponse<void>(data: null, message: 'Profile updated.');
      },
    );
  }
}
