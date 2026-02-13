import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/auth_form_states.dart';
import '../state/auth_validators.dart';
import '../widget/auth_link_button.dart';
import '../widget/auth_message_banner.dart';
import '../widget/auth_password_field.dart';
import '../widget/auth_scaffold.dart';
import '../widget/auth_text_field.dart';
import '../../../../core/component/reactive_notifier/process_notifier.dart';
import '../../../../core/component/reactive_notifier/widget/process_notifier_button.dart';
import '../../../../core/component/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/debug/debug_service.dart';
import '../../../../core/utils/helpers/handle_future_request.dart';
import '../../../../core/di/service_locator.dart';
import '../../model/signup_request.dart';
import '../../repo/auth_repository.dart';
import 'email_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupFormState _form = SignupFormState();
  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled(message: ''));
  late final SnackbarNotifier snackbarNotifier;

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
  }

  Future<void> _submit() async {
    if (!_form.validate()) {
      return;
    }
    await handleFutureRequest(
      futureRequest: () => serviceLocator<AuthRepository>().signup(
        SignupRequest(
          userName: _form.userNameController.text.trim(),
          email: _form.emailController.text.trim(),
          password: _form.passwordController.text,
        ),
      ),
      debugger: AuthDebugger(),
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccessWithoutData: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const EmailVerificationScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create account',
      subtitle: 'Set up your new account in seconds.',
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
              controller: _form.userNameController,
              onChanged: (text) => processStatusNotifier.setEnabled(),
              label: 'Username',
              hintText: 'john_doe',
              textInputAction: TextInputAction.next,
              validator: AuthValidators.userName,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9]')),
              ],
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _form.emailController,
              onChanged: (text) => processStatusNotifier.setEnabled(),
              label: 'Email',
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: AuthValidators.email,
            ),
            const SizedBox(height: 16),
            AuthPasswordField(
              controller: _form.passwordController,
              onChanged: (text) => processStatusNotifier.setEnabled(),
              isVisible: _form.isPasswordVisible,
              label: 'Password',
              validator: AuthValidators.strongPassword,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            RProcessNotifierButton(
              key: const ValueKey('signup-button'),
              processStatusNotifier: processStatusNotifier,
              generalText: 'Sign up',
              loadingText: 'Creating',
              errorText: 'Try again',
              doneText: 'Done',
              onSave: (_) => _submit(),
              onDone: () => processStatusNotifier.setEnabled(message: ''),
            ),
            const SizedBox(height: 20),
            AuthLinkButton(
              label: 'Already have an account? Login',
              onPressed: () => Navigator.of(context).pop(),
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
