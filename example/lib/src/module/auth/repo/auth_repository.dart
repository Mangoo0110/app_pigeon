import 'package:example/src/core/api_handler/api_response.dart';
import 'package:app_pigeon/app_pigeon.dart';
import '../../../core/api_handler/api_handler.dart';
import '../model/authenticated_user.dart';
import '../model/email_verification_request.dart';
import '../model/forget_password_request.dart';
import '../model/login_request.dart';
import '../model/reset_password_request.dart';
import '../model/signup_request.dart';

abstract class AuthRepository with ErrorHandler {
  AsyncRequest<void> login(LoginRequest request);
  AsyncRequest<void> signup(SignupRequest request);
  Stream<AuthenticatedUser?> get authStream;

  AsyncRequest<void> logout();
  AsyncRequest<void> forgotPassword(ForgetPasswordRequest request);
  AsyncRequest<void> resetPassword(ResetPasswordRequest request);
  AsyncRequest<void> verifyEmail(EmailVerificationRequest request);
  AsyncRequest<List<Auth>> fetchAllAccounts();
  AsyncRequest<void> switchAccount({required String uid});
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
  Future<ApiResponse<void>> forgotPassword(
    ForgetPasswordRequest request,
  ) async {
    return _notImplemented('Forgot password');
  }

  @override
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    return _notImplemented('Reset password');
  }

  @override
  Future<ApiResponse<void>> verifyEmail(
    EmailVerificationRequest request,
  ) async {
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

  @override
  // TODO: implement authStream
  Stream<AuthenticatedUser?> get authStream => throw UnimplementedError();
}
