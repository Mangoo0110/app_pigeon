import 'package:flutter/material.dart';

import '../../../../core/component/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/utils/debug/debug_service.dart';
import 'package:example/src/core/di/service_locator.dart';
import 'package:example/src/core/utils/helpers/handle_future_request.dart';
import 'package:example/src/module/auth/repo/auth_repository.dart';
import '../../model/login_request.dart';
import '../state/auth_form_states.dart';
import '../state/auth_validators.dart';
import '../widget/auth_link_button.dart';
import '../widget/auth_message_banner.dart';
import '../widget/auth_password_field.dart';
import '../widget/auth_scaffold.dart';
import '../widget/auth_text_field.dart';
import '../../../../core/component/reactive_notifier/process_notifier.dart';
import '../../../../core/component/reactive_notifier/widget/process_notifier_button.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    this.showBack = false,
    super.key,
  });

  final bool showBack;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginFormState _form = LoginFormState();
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
      futureRequest: () => serviceLocator<AuthRepository>().login(
        LoginRequest(email: _form.emailController.text, password: _form.passwordController.text),
      ),
      debugger: AuthDebugger(),
      processStatusNotifier: processStatusNotifier,
      successSnackbarNotifier: snackbarNotifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to continue using app_pigeon.',
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
              controller: _form.emailController,
              label: 'Email',
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: AuthValidators.email,
            ),
            const SizedBox(height: 16),
            AuthPasswordField(
              controller: _form.passwordController,
              isVisible: _form.isPasswordVisible,
              validator: AuthValidators.password,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: AuthLinkButton(
                label: 'Forgot password?',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            RProcessNotifierButton(
              key: const ValueKey('login-button'),
              processStatusNotifier: processStatusNotifier,
              generalText: 'Login',
              loadingText: 'Logging in',
              errorText: 'Try again',
              doneText: 'Done',
              onSave: (_) => _submit(),
              onDone: () =>
                  processStatusNotifier.setEnabled(message: ''),
            ),
            const SizedBox(height: 20),
            AuthLinkButton(
              label: 'Create an account',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(),
                  ),
                );
              },
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
