import 'package:flutter/material.dart';
import 'package:app_pigeon/app_pigeon.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/routing/route_names.dart';
import '../../../../core/api_handler/api_response.dart';
import '../../../../core/component/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/debug/debug_service.dart';
import '../../../../core/utils/helpers/handle_future_request.dart';
import '../../../auth/model/authenticated_user.dart';
import '../../model/login_request.dart';
import '../../repo/auth_repository.dart';
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
  List<Auth> _accounts = const <Auth>[];
  bool _loadingAccounts = true;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
    _loadAccounts();
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

  Future<void> _loadAccounts() async {
    final response = await serviceLocator<AuthRepository>().fetchAllAccounts();
    if (!mounted) return;
    if (response is SuccessResponse<List<Auth>>) {
      setState(() {
        _accounts = response.data ?? <Auth>[];
        _loadingAccounts = false;
      });
      return;
    }
    setState(() => _loadingAccounts = false);
  }

  String _accountLabel(Auth auth) {
    final data = auth.data;
    final email = data['email']?.toString().trim();
    if (email != null && email.isNotEmpty) return email;
    final name = data['userName']?.toString().trim();
    if (name != null && name.isNotEmpty) return name;
    return 'Saved account';
  }

  String? _accountUid(Auth auth) {
    final data = auth.data;
    for (final key in const ['uid', 'user_id', 'userId', 'id']) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  Future<void> _selectSavedAccount() async {
    if (_accounts.isEmpty) return;
    final selected = await showModalBottomSheet<Auth>(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _accounts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final account = _accounts[index];
              return ListTile(
                title: Text(_accountLabel(account)),
                subtitle: Text(_accountUid(account) ?? '-'),
                onTap: () => Navigator.of(context).pop(account),
              );
            },
          ),
        );
      },
    );
    if (selected == null) return;
    final uid = _accountUid(selected);
    if (uid == null) return;
    await serviceLocator<AuthRepository>().switchAccount(uid: uid);
  }

  Future<void> _continueAsGuest() async {
    final input = await _promptGhostIdentityInput();
    if (input == null) return;
    final normalizedUserName = input.userName.trim().toLowerCase();
    String resolvedGhostId = '';

    try {
      if (input.hasPasskey) {
        final loginRes = await ghostPigeon.post(
          ApiEndpoints.ghostLogin,
          data: <String, dynamic>{
            'userName': normalizedUserName,
            'passkey': input.passkey,
          },
        );
        final data = loginRes.data['data'];
        if (data is Map<String, dynamic>) {
          final incomingId = data['ghostId']?.toString().trim();
          if (incomingId != null && incomingId.isNotEmpty) {
            resolvedGhostId = incomingId;
          }
        }
      } else {
        final registerRes = await ghostPigeon.post(
          ApiEndpoints.ghostRegister,
          data: <String, dynamic>{'userName': normalizedUserName},
        );
        final data = registerRes.data['data'];
        if (data is Map<String, dynamic>) {
          final incomingId = data['ghostId']?.toString().trim();
          if (incomingId != null && incomingId.isNotEmpty) {
            resolvedGhostId = incomingId;
          }
          final passkey = data['passkey']?.toString();
          if (passkey != null && passkey.isNotEmpty && mounted) {
            await _showGhostPasskey(passkey);
          }
        }
      }
    } catch (_) {
      processStatusNotifier.setError(
        message: input.hasPasskey
            ? 'Ghost login failed. Check username/passkey.'
            : 'Failed to create ghost identity.',
      );
      return;
    }

    if (resolvedGhostId.isEmpty) {
      processStatusNotifier.setError(
        message: 'Invalid ghost session response.',
      );
      return;
    }

    final resolver = serviceLocator<ActivePigeonResolver>();
    resolver.useGhost();
    authorizedPigeon.disconnectSocket();
    final guest = AuthenticatedUser.guest(
      uid: resolvedGhostId,
      userName: normalizedUserName,
    );
    await AppRouter.navigateToReplacement(RouteNames.app, guest);
  }

  Future<void> _showGhostPasskey(String passkey) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your ghost passkey',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SelectableText(
                  passkey,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  maxLines: 10,
                  'Save this key now. You will need it to login with this ghost identity next time.',
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('I saved it'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<_GhostIdentityInput?> _promptGhostIdentityInput() async {
    String? validationMessage;
    String usernameValue = '';
    String passkeyValue = '';
    bool hasPasskey = false;
    final result = await showDialog<_GhostIdentityInput>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Continue as ghost'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Ghost username',
                      hintText: 'e.g. ghostfox',
                      errorText: validationMessage,
                    ),
                    onChanged: (value) {
                      usernameValue = value;
                      if (validationMessage != null) {
                        setLocalState(() => validationMessage = null);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: hasPasskey,
                    title: const Text('I have existing passkey'),
                    onChanged: (value) {
                      setLocalState(() => hasPasskey = value);
                    },
                  ),
                  if (hasPasskey)
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Passkey',
                        hintText: '6 characters',
                      ),
                      onChanged: (value) {
                        passkeyValue = value.trim().toUpperCase();
                        if (validationMessage != null) {
                          setLocalState(() => validationMessage = null);
                        }
                      },
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use lowercase letters, numbers, and underscore only.',
                    maxLines: 10,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final value = usernameValue.trim().toLowerCase();
                    final isValid = RegExp(r'^[a-z0-9_]{3,24}$').hasMatch(value);
                    if (!isValid) {
                      setLocalState(() {
                        validationMessage = '3-24 chars: a-z, 0-9, _';
                      });
                      return;
                    }
                    if (hasPasskey && passkeyValue.length != 6) {
                      setLocalState(() {
                        validationMessage = 'Passkey must be 6 characters.';
                      });
                      return;
                    }
                    Navigator.of(context).pop(
                      _GhostIdentityInput(
                        userName: value,
                        hasPasskey: hasPasskey,
                        passkey: passkeyValue,
                      ),
                    );
                  },
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        );
      },
    );
    return result;
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
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _loadingAccounts || _accounts.isEmpty
                  ? null
                  : _selectSavedAccount,
              icon: _loadingAccounts
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_drop_down_circle_outlined),
              label: Text(
                _loadingAccounts
                    ? 'Loading saved accounts...'
                    : _accounts.isEmpty
                    ? 'No saved accounts'
                    : 'Use saved account',
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _continueAsGuest,
              child: const Text('Continue as guest'),
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

class _GhostIdentityInput {
  const _GhostIdentityInput({
    required this.userName,
    required this.hasPasskey,
    required this.passkey,
  });

  final String userName;
  final bool hasPasskey;
  final String passkey;
}
