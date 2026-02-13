import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';

import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/core/di/service_locator.dart';
import 'package:example/src/core/utils/debug/debug_service.dart';
import 'package:example/src/core/utils/helpers/handle_future_request.dart';
import '../../repo/auth_repository.dart';
import '../widget/auth_account_tile.dart';
import '../widget/auth_message_banner.dart';
import '../../../../core/component/reactive_notifier/process_notifier.dart';
import '../../../../core/component/reactive_notifier/widget/process_notifier_button.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final ProcessStatusNotifier _messageProcess =
      ProcessStatusNotifier(initialStatus: ProcessEnabled(message: ''));
  late Future<List<Auth>> _accountsFuture;
  late Future<Auth?> _currentFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reload();
  }

  @override
  void dispose() {
    _messageProcess.dispose();
    super.dispose();
  }

  void _reload() {
    _accountsFuture =
        serviceLocator<AuthRepository>().fetchAllAccounts().then((response) {
      if (response is ErrorResponse<List<Auth>>) {
        _messageProcess.setError(message: response.message);
        _scheduleReset(_messageProcess);
        return <Auth>[];
      }
      return response.data ?? <Auth>[];
    });
    _currentFuture = serviceLocator<AuthorizedAppPigeon>().getCurrentAuthRecord();
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _accountsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _messageProcess,
                    builder: (context, _) {
                      final status = _messageProcess.status;
                      return AuthMessageBanner(
                        message: status.message,
                        color: _bannerColor(context, status),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<Auth?>(
                    future: _currentFuture,
                    builder: (context, snapshot) {
                      final current = snapshot.data;
                      if (current == null) {
                        return const ListTile(
                          title: Text('No current account'),
                        );
                      }
                      return ListTile(
                        title: const Text('Current account'),
                        subtitle: Text(
                          current.data['email']?.toString() ?? 'Unknown',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  RProcessNotifierButton(
                    key: const ValueKey('accounts-logout-button'),
                    processStatusNotifier: _messageProcess,
                    generalText: 'Logout',
                    loadingText: 'Logging out',
                    errorText: 'Try again',
                    doneText: 'Done',
                    onSave: (_) async {
                      await handleFutureRequest<void>(
                        futureRequest: () =>
                            serviceLocator<AuthRepository>().logout(),
                        debugger: AuthDebugger(),
                        processStatusNotifier: _messageProcess,
                      );
                      setState(_reload);
                    },
                    onDone: () => _messageProcess.setEnabled(message: ''),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: FutureBuilder<List<Auth>>(
                  future: _accountsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final accounts = snapshot.data ?? <Auth>[];
                    if (accounts.isEmpty) {
                      return ListView(
                        children: [
                          SizedBox(height: 32),
                          Center(child: Text('No stored accounts')),
                        ],
                      );
                    }
                    return ListView.separated(
                      itemCount: accounts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final auth = accounts[index];
                        return AuthAccountTile(
                          auth: auth,
                          onSwitch: () async {
                            final response =
                                await serviceLocator<AuthRepository>()
                                    .switchAccount(
                              uid: auth.data['uid']?.toString() ??
                                  auth.data['id']?.toString() ??
                                  '',
                            );
                            if (response is ErrorResponse) {
                              _messageProcess.setError(message: response.message);
                            } else {
                              _messageProcess.setSuccess(message: response.message);
                            }
                            _scheduleReset(_messageProcess);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleReset(ProcessStatusNotifier notifier) {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        notifier.setEnabled(message: '');
      }
    });
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
