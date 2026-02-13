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
import '../../model/email_verification_request.dart';
import '../../repo/auth_repository.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({this.userId, this.showBack = true, super.key});

  final String? userId;
  final bool showBack;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final EmailVerificationFormState _form = EmailVerificationFormState();
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: ProcessEnabled(message: ''),
  );
  late final SnackbarNotifier snackbarNotifier;

  @override
  void initState() {
    super.initState();
    final userId = widget.userId;
    if (userId != null && userId.isNotEmpty) {
      _form.userIdController.text = userId;
    }
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
      futureRequest: () => serviceLocator<AuthRepository>().verifyEmail(
        EmailVerificationRequest(
          userId: _form.userIdController.text.trim(),
          verificationCode: _form.codeController.text.trim(),
        ),
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
      title: 'Verify email',
      subtitle: 'Enter the code sent to your inbox.',
      showBack: widget.showBack,
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
              controller: _form.userIdController,
              onChanged: (text) => processStatusNotifier.setEnabled(),
              label: 'User ID or Email',
              hintText: 'user_id or you@example.com',
              textInputAction: TextInputAction.next,
              validator: AuthValidators.userId,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _form.codeController,
              onChanged: (text) => processStatusNotifier.setEnabled(),
              label: 'Verification code',
              hintText: '123456',
              textInputAction: TextInputAction.done,
              validator: AuthValidators.verificationCode,
            ),
            const SizedBox(height: 16),
            RProcessNotifierButton(
              key: const ValueKey('verify-email-button'),
              processStatusNotifier: processStatusNotifier,
              generalText: 'Verify',
              loadingText: 'Verifying',
              errorText: 'Try again',
              doneText: 'Verified',
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
