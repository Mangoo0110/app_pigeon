import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/di/service_locator.dart';
import 'package:flutter/material.dart';

import 'package:example/src/core/di/service_locator.dart';
import 'authenticated_home_screen.dart';
import 'email_verification_screen.dart';
import 'login_screen.dart';

class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthStatus>(
      stream: serviceLocator<AppPigeon>().authStream,
      builder: (context, snapshot) {
        final status = snapshot.data ?? UnAuthenticated();
        final resolved = _resolveStatus(status);
        return Navigator(
          pages: [
            MaterialPage(
              key: ValueKey(resolved.key),
              child: resolved.screen,
            ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }

  _ResolvedScreen _resolveStatus(AuthStatus status) {
    if (status is AuthError) {
      return _ResolvedScreen(
        key: 'error',
        screen: _AuthErrorScreen(message: status.error),
      );
    }
    if (status is Authenticated) {
      if (!status.auth.isVerified) {
        return _ResolvedScreen(
          key: 'verify',
          screen: EmailVerificationScreen(
            userId: _extractUserId(status.auth.data),
            showBack: false,
          ),
        );
      }
      return _ResolvedScreen(
        key: 'authenticated',
        screen: AuthenticatedHomeScreen(auth: status.auth),
      );
    }
    if (status is NotVerified) {
      return _ResolvedScreen(
        key: 'verify',
        screen: EmailVerificationScreen(
          userId: status.userId,
          showBack: false,
        ),
      );
    }
    if (status is UnAuthenticated) {
      return const _ResolvedScreen(
        key: 'login',
        screen: LoginScreen(),
      );
    }
    return const _ResolvedScreen(
      key: 'loading',
      screen: _AuthLoadingScreen(),
    );
  }

  String? _extractUserId(Map<String, dynamic> data) {
    for (final key in ['uid', 'user_id', 'userId', 'id']) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}

class _ResolvedScreen {
  const _ResolvedScreen({
    required this.key,
    required this.screen,
  });

  final String key;
  final Widget screen;
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _AuthErrorScreen extends StatelessWidget {
  const _AuthErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Something went wrong'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message),
        ),
      ),
    );
  }
}
