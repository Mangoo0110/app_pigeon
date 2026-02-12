import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/core/api_handler/error_handler.dart';

import 'package:app_pigeon/app_pigeon.dart';
import '../model/email_verification_request.dart';
import '../model/forget_password_request.dart';
import '../model/login_request.dart';
import '../model/signup_request.dart';

abstract class AuthRepository with ErrorHandler{
  Future<ApiResponse<void>> login(LoginRequest request);
  Future<ApiResponse<void>> signup(SignupRequest request);

  Future<ApiResponse<void>> logout();
  Future<ApiResponse<void>> forgotPassword(ForgetPasswordRequest request);
  Future<ApiResponse<void>> verifyEmail(EmailVerificationRequest request);
  Future<ApiResponse<List<Auth>>> fetchAllAccounts();
  Future<ApiResponse<void>> switchAccount({required String uid});
}

class AuthRepositoryStub extends AuthRepository {
  ApiResponse<T> _notImplemented<T>(String feature) {
    return ErrorResponse(
      message: '$feature is not implemented yet.',
      exception: Exception('Not implemented'),
      stackTrace: StackTrace.current,
    );
  }

  @override
  Future<ApiResponse<void>> login(LoginRequest request) async {
    return _notImplemented('Login');
  }

  @override
  Future<ApiResponse<void>> signup(SignupRequest request) async {
    return _notImplemented('Signup');
  }

  @override
  Future<ApiResponse<void>> logout() async {
    return _notImplemented('Logout');
  }

  @override
  Future<ApiResponse<void>> forgotPassword(ForgetPasswordRequest request) async {
    return _notImplemented('Forgot password');
  }

  @override
  Future<ApiResponse<void>> verifyEmail(EmailVerificationRequest request) async {
    return _notImplemented('Email verification');
  }
  
  @override
  Future<ApiResponse<List<Auth>>> fetchAllAccounts() async {
    return _notImplemented('Fetch accounts');
  }

  @override
  Future<ApiResponse<void>> switchAccount({required String uid}) async {
    return _notImplemented('Switch account');
  }
}
