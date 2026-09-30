import 'package:example/src/app/view/authenticated_home_screen.dart';
import 'package:example/src/core/di/service_locator.dart';
import 'package:example/src/module/auth/repo/auth_repository.dart';
import 'package:flutter/material.dart';

import '../../model/authenticated_user.dart';
import 'email_verification_screen.dart';
import 'login_screen.dart';

class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticatedUser?>(
      stream: serviceLocator<AuthRepository>().authStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        final resolved = _resolveStatus(user);
        return Navigator(
          pages: [
            MaterialPage(key: ValueKey(resolved.key), child: resolved.screen),
          ],
          onDidRemovePage: (_) {},
        );
      },
    );
  }

  _ResolvedScreen _resolveStatus(AuthenticatedUser? user) {
    if (user == null) {
      return const _ResolvedScreen(key: 'login', screen: LoginScreen());
    }

    if (user.isVerified) {
      return _ResolvedScreen(
        key: 'authenticated',
        screen: AuthenticatedHomeScreen(currentAuth: user),
      );
    }

    return _ResolvedScreen(
      key: 'verify',
      screen: EmailVerificationScreen(userId: user.uid, showBack: false),
    );
  }
}

class _ResolvedScreen {
  const _ResolvedScreen({required this.key, required this.screen});

  final String key;
  final Widget screen;
}
