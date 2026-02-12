import 'package:flutter/material.dart';

import '../state/auth_form_states.dart';
import '../state/auth_validators.dart';
import '../widget/auth_message_banner.dart';
import '../widget/auth_scaffold.dart';
import '../widget/auth_text_field.dart';
import '../../../../core/component/reactive_notifier/process_notifier.dart';
import '../../../../core/component/reactive_notifier/widget/process_notifier_button.dart';
import '../../../../core/component/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/debug/debug_service.dart';
import '../../../../core/utils/helpers/handle_future_request.dart';
import '../../../../core/di/service_locator.dart';
import '../../model/forget_password_request.dart';
import '../../repo/auth_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordFormState _form = ForgotPasswordFormState();
  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled(message: ''));
  late final SnackbarNotifier snackbarNotifier;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.validate()) {
      return;
    }
    await handleFutureRequest(
      futureRequest: () => serviceLocator<AuthRepository>().forgotPassword(
        ForgetPasswordRequest(email: _form.emailController.text.trim()),
      ),
      debugger: AuthDebugger(),
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Forgot password',
      subtitle: 'We will send a reset link to your email.',
      child: Form(
        key: _form.formKey,
        child: Column(
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
            AuthTextField(
              controller: _form.emailController,
              label: 'Email',
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: AuthValidators.email,
            ),
            const SizedBox(height: 16),
            RProcessNotifierButton(
              key: const ValueKey('forgot-password-button'),
              processStatusNotifier: processStatusNotifier,
              generalText: 'Send reset link',
              loadingText: 'Sending',
              errorText: 'Try again',
              doneText: 'Sent',
              onSave: (_) => _submit(),
              onDone: () => processStatusNotifier.setEnabled(message: ''),
            ),
          ],
        ),
      ),
    );
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
