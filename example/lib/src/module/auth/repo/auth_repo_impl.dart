import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/core/constants/api_endpoints.dart';
import 'package:example/src/module/auth/model/auth_payload.dart';
import 'package:example/src/module/auth/model/authenticated_user.dart';
import 'package:example/src/module/auth/model/email_verification_request.dart';
import 'package:example/src/module/auth/model/forget_password_request.dart';
import 'package:example/src/module/auth/model/login_request.dart';
import 'package:example/src/module/auth/model/reset_password_request.dart';
import 'package:example/src/module/auth/model/signup_request.dart';
import 'package:example/src/module/auth/repo/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthRepoImpl extends AuthRepository {
  final AuthorizedPigeon appPigeon;

  AuthRepoImpl(this.appPigeon);

  @override
  AsyncRequest<void> forgotPassword(ForgetPasswordRequest request) {
    return asyncTryCatch(
      tryFunc: () async {
        final res = await appPigeon.post(
          ApiEndpoints.forgotPassword,
          data: request.toJson(),
        );
        final message = extractSuccessMessage(res) ?? 'Reset OTP sent.';
        return SuccessResponse<void>(data: null, message: message);
      },
    );
  }

  @override
  AsyncRequest<void> resetPassword(ResetPasswordRequest request) {
    return asyncTryCatch(
      tryFunc: () async {
        final res = await appPigeon.post(
          ApiEndpoints.resetPassword,
          data: request.toJson(),
        );
        final message =
            extractSuccessMessage(res) ?? 'Password reset successful.';
        return SuccessResponse<void>(data: null, message: message);
      },
    );
  }

  @override
  AsyncRequest<void> login(LoginRequest request) async {
    return asyncTryCatch(
      tryFunc: () async {
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
        var message = extractSuccessMessage(res) ?? 'Login successful.';
        try {
          final profileRes = await appPigeon.get(ApiEndpoints.userProfile);
          final profileData = extractBodyData(profileRes);
          final isVerified =
              profileData is Map<String, dynamic> &&
              (profileData['isVerified'] == true ||
                  profileData['emailVerified'] == true);
          if (!isVerified) {
            message = '$message Warning: email is not verified yet.';
          }
        } catch (_) {
          // Keep login success if profile warning check fails.
        }
        return SuccessResponse<void>(data: null, message: message);
      },
    );
  }

  @override
  AsyncRequest<void> logout() async {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.logOut();
        return SuccessResponse<void>(
          data: null,
          message: 'You are now logged out!',
        );
      },
    );
  }

  @override
  AsyncRequest<void> signup(SignupRequest request) async {
    return asyncTryCatch(
      tryFunc: () async {
        debugPrint("Request: ${request.toJson()}");
        final res = await appPigeon.post(
          ApiEndpoints.signup,
          data: request.toJson(),
        );
        final message = extractSuccessMessage(res) ?? 'Signup successful.';
        return SuccessResponse<void>(data: null, message: message);
      },
    );
  }

  @override
  AsyncRequest<void> verifyEmail(EmailVerificationRequest request) {
    return asyncTryCatch(
      tryFunc: () async {
        final res = await appPigeon.post(
          ApiEndpoints.verifyEmail,
          data: request.toJson(),
        );
        final message = extractSuccessMessage(res) ?? 'Email verified.';
        return SuccessResponse<void>(data: null, message: message);
      },
    );
  }

  @override
  AsyncRequest<List<Auth>> fetchAllAccounts() async {
    return asyncTryCatch(
      tryFunc: () async {
        final res = await appPigeon.getAllAuthRecords();
        return SuccessResponse<List<Auth>>(
          data: res,
          message: "${res.length} Accounts!",
        );
      },
    );
  }

  @override
  AsyncRequest<void> switchAccount({required String uid}) {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.switchAccount(uid: uid);
        return SuccessResponse<void>(data: null, message: 'Switched account');
      },
    );
  }

  @override
  Stream<AuthenticatedUser?> get authStream =>
      appPigeon.authStream.map((state) {
        debugPrint('Auth state changed: $state');
        try {
          if (state is Authenticated) {
            return AuthenticatedUser.fromAuthenticateState(state);
          }
          return null;
        } catch (e, s) {
          debugPrint(s.toString());
          return null;
        }
      });
}
