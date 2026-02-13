import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/utils/extensions/auth_ext.dart';

class AuthenticatedUser {
  final String uid;
  final bool isVerified;
  final String userName;
  final bool isGuest;

  AuthenticatedUser._({
    required this.uid,
    required this.isVerified,
    required this.userName,
    required this.isGuest,
  });

  factory AuthenticatedUser.fromAuthenticateState(Authenticated auth) {
    return AuthenticatedUser._(
      uid: auth.userId,
      isVerified: auth.isVerified,
      userName: auth.userName,
      isGuest: false,
    );
  }

  factory AuthenticatedUser.guest({
    required String uid,
    required String userName,
  }) {
    return AuthenticatedUser._(
      uid: uid,
      isVerified: true,
      userName: userName,
      isGuest: true,
    );
  }
}
