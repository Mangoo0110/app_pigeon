import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _LocalHostWifi.socketUrl;

  static const String baseUrl = _LocalHostWifi.baseUrl;
  
  // ---------------------- AUTH -----------------------------
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  /// ### post
  static const String login = "$_authRoute/login";
  static const String signup = "$_authRoute/register";
  static const String refreshToken = "$_authRoute/refresh";
  static const String logout = "$_authRoute/logout";
  static const String forgotPassword = "$_authRoute/forgot-password";
  static const String resetPassword = "$_authRoute/reset-password";
  static const String verifyEmail = "$_authRoute/verify-email";

  // ---------------------- USER -----------------------------
  static const String _userRoute = '${ApiEndpoints.baseUrl}/user';
  /// ### get
  static const String userProfile = "$_userRoute/profile";

  // ---------------------- Message -----------------------------

}

class _RemoteServer {
  static const String socketUrl =
      '';

  static const String baseUrl =
      '';
}

class _LocalHostWifi {
  static const String socketUrl = 'http://192.168.0.100:3001';

  static const String baseUrl = 'http://192.168.0.100:3001/api/v1';
}



// ---------------------- Notification -----------------------------
class _Notification {
  static const String _notificationRoute =
      '${ApiEndpoints.baseUrl}/notification';
}

// ---------------------- MESSAGE -----------------------------
class _Message {
  static const String _messageRoute = '${ApiEndpoints.baseUrl}/message';
}
