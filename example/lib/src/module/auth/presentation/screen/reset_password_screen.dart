import 'package:flutter/material.dart';

import '../state/auth_form_states.dart';
import '../state/auth_validators.dart';
import '../widget/auth_message_banner.dart';
import '../widget/auth_password_field.dart';
import '../widget/auth_scaffold.dart';
import '../widget/auth_text_field.dart';
import '../../../../core/component/reactive_notifier/process_notifier.dart';
import '../../../../core/component/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/component/reactive_notifier/widget/process_notifier_button.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/debug/debug_service.dart';
import '../../../../core/utils/helpers/handle_future_request.dart';
import '../../model/reset_password_request.dart';
import '../../repo/auth_repository.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({this.email, super.key});

  final String? email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordFormState _form = ResetPasswordFormState();
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: ProcessEnabled(message: ''),
  );
  late final SnackbarNotifier snackbarNotifier;

  @override
  void initState() {
    super.initState();
    if (widget.email != null && widget.email!.trim().isNotEmpty) {
      _form.emailController.text = widget.email!.trim();
    }
    snackbarNotifier = SnackbarNotifier(context: context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.validate()) return;
    await handleFutureRequest(
      futureRequest: () => serviceLocator<AuthRepository>().resetPassword(
        ResetPasswordRequest(
          email: _form.emailController.text.trim(),
          verificationCode: _form.otpController.text.trim(),
          newPassword: _form.newPasswordController.text,
        ),
      ),
      debugger: AuthDebugger(),
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccessWithoutData: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset password',
      subtitle: 'Enter your OTP and set a new password.',
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
              onChanged: (_) => processStatusNotifier.setEnabled(),
              label: 'Email',
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: AuthValidators.email,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _form.otpController,
              onChanged: (_) => processStatusNotifier.setEnabled(),
              label: 'OTP code',
              hintText: '123456',
              textInputAction: TextInputAction.next,
              validator: AuthValidators.verificationCode,
            ),
            const SizedBox(height: 16),
            AuthPasswordField(
              controller: _form.newPasswordController,
              onChanged: (_) => processStatusNotifier.setEnabled(),
              isVisible: _form.isPasswordVisible,
              label: 'New password',
              validator: AuthValidators.strongPassword,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            RProcessNotifierButton(
              key: const ValueKey('reset-password-button'),
              processStatusNotifier: processStatusNotifier,
              generalText: 'Reset password',
              loadingText: 'Resetting',
              errorText: 'Try again',
              doneText: 'Done',
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
