import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/core/constants/api_endpoints.dart';
import 'package:example/src/module/auth/model/auth_payload.dart';
import 'package:example/src/module/auth/model/email_verification_request.dart';
import 'package:example/src/module/auth/model/forget_password_request.dart';
import 'package:example/src/module/auth/model/login_request.dart';
import 'package:example/src/module/auth/model/signup_request.dart';
import 'package:example/src/module/auth/repo/auth_repository.dart';

class AuthRepoImpl extends AuthRepository{

  final AppPigeon appPigeon;

  AuthRepoImpl(this.appPigeon);

  @override
  Future<ApiResponse<void>> forgotPassword(ForgetPasswordRequest request) {
    return asyncTryCatch(tryFunc: () async {
      final res = await appPigeon.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );
      final message = extractSuccessMessage(res) ?? 'Reset link sent.';
      return SuccessResponse<void>(data: null, message: message);
    });
  }

  @override
  Future<ApiResponse<void>> login(LoginRequest request) async {
    return asyncTryCatch(tryFunc: () async {
      final res = await appPigeon.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      final resData = extractBodyData(res);
      final auth = AuthPayload.fromJson(
        resData is Map<String, dynamic> ? resData : <String, dynamic>{},
      );
      await appPigeon.saveNewAuth(
        saveAuthParams: SaveNewAuthParams(
          accessToken: auth.accessToken,
          refreshToken: auth.refreshToken,
          uid: auth.uid,
          data: auth.data,
        ),
      );
      final message = extractSuccessMessage(res) ?? 'Login successful.';
      return SuccessResponse<void>(data: null, message: message);
    });
  }

  @override
  Future<ApiResponse<void>> logout() async {
    return asyncTryCatch(tryFunc: () async {
      await appPigeon.post(ApiEndpoints.logout);
      return SuccessResponse<void>(data: null, message: 'You are now logged out!');
    });
  }

  @override
  Future<ApiResponse<void>> signup(SignupRequest request) async {
    return asyncTryCatch(tryFunc: () async {
      final res = await appPigeon.post(
        ApiEndpoints.signup,
        data: request.toJson(),
      );
      final resData = extractBodyData(res);
      final auth = AuthPayload.fromJson(
        resData is Map<String, dynamic> ? resData : <String, dynamic>{},
      );
      await appPigeon.saveNewAuth(
        saveAuthParams: SaveNewAuthParams(
          accessToken: auth.accessToken,
          refreshToken: auth.refreshToken,
          uid: auth.uid,
          data: auth.data,
        ),
      );
      final message = extractSuccessMessage(res) ?? 'Signup successful.';
      return SuccessResponse<void>(data: null, message: message);
    });
  }


  @override
  Future<ApiResponse<void>> verifyEmail(EmailVerificationRequest request) {
    return asyncTryCatch(tryFunc: () async {
      final res = await appPigeon.post(
        ApiEndpoints.verifyEmail,
        data: request.toJson(),
      );
      final message = extractSuccessMessage(res) ?? 'Email verified.';
      return SuccessResponse<void>(data: null, message: message);
    });
  }
  
  @override
  Future<ApiResponse<List<Auth>>> fetchAllAccounts() async{
    return asyncTryCatch(tryFunc: () async {
      final res = await appPigeon.getAllAuthRecords();
      return SuccessResponse<List<Auth>>(data: res, message: "${res.length} Accounts!");
    });
  }
  
  @override
  Future<ApiResponse<void>> switchAccount({required String uid}) {
    return asyncTryCatch(tryFunc: () async {
      await appPigeon.switchAccount(uid: uid);
      return SuccessResponse<void>(data: null, message: 'Switched account');
    });
  }

  // @override
  // Future<ApiResponse<AuthPayload>> socialLogin({
  //   required String provider,
  //   required String accessToken,
  //   String? idToken,
  // }) {
  //   return asyncTryCatch(tryFunc: () async {
  //     final res = await appPigeon.post(
  //       ApiEndpoints.socialLogin,
  //       data: {
  //         'provider': provider,
  //         'access_token': accessToken,
  //         if (idToken != null) 'id_token': idToken,
  //       },
  //     );
  //     final resData = extractBodyData(res);
  //     final auth = AuthPayload.fromJson(
  //       resData is Map<String, dynamic> ? resData : <String, dynamic>{},
  //     );
  //     final message = extractSuccessMessage(res) ?? 'Login successful.';
  //     return SuccessResponse<AuthPayload>(data: auth, message: message);
  //   });
  // }


}
