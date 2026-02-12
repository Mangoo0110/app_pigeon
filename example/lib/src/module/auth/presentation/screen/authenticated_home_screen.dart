import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';

import '../widget/auth_message_banner.dart';
import '../widget/auth_scaffold.dart';
import '../../../../core/component/reactive_notifier/process_notifier.dart';
import '../../../../core/component/reactive_notifier/widget/process_notifier_button.dart';
import '../../../../core/component/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/helpers/handle_future_request.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/debug/debug_service.dart';
import '../../repo/auth_repository.dart';

class AuthenticatedHomeScreen extends StatefulWidget {
  const AuthenticatedHomeScreen({
    required this.auth,
    super.key,
  });

  final Auth auth;

  @override
  State<AuthenticatedHomeScreen> createState() =>
      _AuthenticatedHomeScreenState();
}

class _AuthenticatedHomeScreenState extends State<AuthenticatedHomeScreen> {
  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled(message: ''));
  late final SnackbarNotifier snackbarNotifier;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
  }

  Future<void> _logout() async {
    await handleFutureRequest<void>(
      futureRequest: () => serviceLocator<AuthRepository>().logout(),
      debugger: AuthDebugger(),
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.auth.data;
    final displayName = _firstNonEmptyString(
      data,
      ['name', 'full_name', 'fullName', 'display_name', 'displayName'],
    );
    final email = _firstNonEmptyString(
      data,
      ['email', 'email_address', 'emailAddress'],
    );
    final userId = _firstNonEmptyString(
      data,
      ['uid', 'user_id', 'userId', 'id'],
    );

    return AuthScaffold(
      title: 'Welcome',
      subtitle: 'You are signed in.',
      showBack: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: processStatusNotifier,
            builder: (context, _) {
              final status = processStatusNotifier.status;
              return AuthMessageBanner(
                message: status.message,
                color: _bannerColor(context, status),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName ?? 'Account',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (email != null) ...[
                    const SizedBox(height: 8),
                    Text(email),
                  ],
                  if (userId != null) ...[
                    const SizedBox(height: 8),
                    Text('User ID: $userId'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          RProcessNotifierButton(
            key: const ValueKey('logout-button'),
            processStatusNotifier: processStatusNotifier,
            generalText: 'Log out',
            loadingText: 'Logging out',
            errorText: 'Try again',
            doneText: 'Done',
            onSave: (_) => _logout(),
            onDone: () => processStatusNotifier.setEnabled(message: ''),
          ),
        ],
      ),
    );
  }

  String? _firstNonEmptyString(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  Color? _bannerColor(BuildContext context, ProcessStatus status) {
    final theme = Theme.of(context);
    if (status is ProcessFailed) {
      return theme.colorScheme.errorContainer;
    }
    if (status is ProcessSuccess) {
      return theme.colorScheme.secondaryContainer;
    }
    return null;
  }
}
