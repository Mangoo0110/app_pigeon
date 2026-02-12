import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/utils/extensions/auth_ext.dart';

class AuthenticatedUser {
  final String uid;
  final bool isVerified;
  final String userName;

  AuthenticatedUser._({
    required this.uid,
    required this.isVerified,
    required this.userName,
  });

  factory AuthenticatedUser.fromAuthenticateState(Authenticated auth) {
    return AuthenticatedUser._(
      uid: auth.userId,
      isVerified: auth.isVerified,
      userName: auth.userName,
    );
  }
}