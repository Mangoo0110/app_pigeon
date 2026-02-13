part of '../authorized_app_pigeon.dart';

sealed class AuthStatus {
  const AuthStatus();

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class UnAuthenticated extends AuthStatus {
  @override
  bool operator ==(Object other) {
    return other is UnAuthenticated;
  }

  @override
  int get hashCode => runtimeType.hashCode;
  @override
  String toString() {
    return 'UnAuthenticated';
  }
}

class AuthLoading extends AuthStatus{
  @override
  bool operator ==(Object other) {
    return other is AuthLoading;
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthLoading';
  }
}

class Authenticated extends AuthStatus {
  final Auth auth;

  // SocketServiceParams get socketServiceParams => SocketServiceParams(
  //   url: ApiEndpoints.socketUrl,
  //   token: auth._accessToken ?? '',
  //   userId: auth.userId,
  // );
  
  Authenticated({required this.auth});

  @override
  String toString() {
    return 'Authenticated(auth: $auth)';
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Authenticated && other.auth == auth;
  }

  @override
  int get hashCode => auth.hashCode;
}


class AuthError extends AuthStatus {
  final String error;
  AuthError({required this.error});

  @override
  String toString() {
    return 'AuthError(error: $error)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

