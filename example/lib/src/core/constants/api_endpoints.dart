import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _RemoteServer.socketUrl;

  static const String baseUrl = _RemoteServer.baseUrl;
  
  // ---------------------- AUTH -----------------------------
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  /// ### post
  static const String login = "$_authRoute/login";
  static const String signup = "$_authRoute/signup";
  static const String refreshToken = "$_authRoute/refresh-token";
  static const String logout = "$_authRoute/logout";
  static const String forgotPassword = "$_authRoute/forgot-password";
  static const String verifyEmail = "$_authRoute/verify-email";

  // ---------------------- USER -----------------------------
  /// ### get

  // ---------------------- Message -----------------------------

}

class _RemoteServer {
  static const String socketUrl =
      '';

  static const String baseUrl =
      '';
}

class _LocalHostWifi {
  static const String socketUrl = 'http://10.10.5.90:5006';

  static const String baseUrl = 'http://10.10.5.90:5006/api/v1';
}



// ---------------------- Notification -----------------------------
class _Notification {
  static const String _notificationRoute =
      '${ApiEndpoints.baseUrl}/notification';
}

class _User {
  static const String _userRoute = '${ApiEndpoints.baseUrl}/user';
}

// ---------------------- MESSAGE -----------------------------
class _Message {
  static const String _messageRoute = '${ApiEndpoints.baseUrl}/message';
}
