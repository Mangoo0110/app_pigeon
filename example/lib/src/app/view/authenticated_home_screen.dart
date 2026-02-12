import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';

import '../../core/api_handler/api_response.dart';
import '../../core/di/service_locator.dart';
import '../../module/auth/model/authenticated_user.dart';
import '../../module/auth/presentation/screen/login_screen.dart';
import '../../module/auth/repo/auth_repository.dart';
import '../../module/chat/presentation/widget/universal_chat_module.dart';
import '../../module/chat/repo/chat_repository.dart';
import '../../module/profile/presentation/widget/account_switch_sheet.dart';
import '../../module/profile/presentation/widget/profile_avatar_action.dart';
import '../../module/profile/repo/profile_repository.dart';

class AuthenticatedHomeScreen extends StatefulWidget {
  const AuthenticatedHomeScreen({
    super.key,
    required this.currentAuth,
  });

  final AuthenticatedUser currentAuth;

  @override
  State<AuthenticatedHomeScreen> createState() =>
      _AuthenticatedHomeScreenState();
}

class _AuthenticatedHomeScreenState extends State<AuthenticatedHomeScreen> {
  Map<String, dynamic> _profile = <String, dynamic>{};
  List<Auth> _accounts = const <Auth>[];
  bool _loading = true;
  bool _socketReady = false;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    if (!mounted) return;
    setState(() => _loading = true);

    final authRepo = serviceLocator<AuthRepository>();
    final profileRepo = serviceLocator<ProfileRepository>();

    final accountsRes = await authRepo.fetchAllAccounts();
    final profileRes = await profileRepo.fetchProfile();

    final accounts = accountsRes is SuccessResponse<List<Auth>>
        ? (accountsRes.data ?? <Auth>[])
        : <Auth>[];
    final profile = profileRes is SuccessResponse<Map<String, dynamic>>
        ? (profileRes.data ?? <String, dynamic>{})
        : <String, dynamic>{};

    if (!mounted) return;
    _accounts = accounts;
    debugPrint('Accounts: ${_accounts.length}');
    _profile = profile;
    setState(() => _loading = false);

    await _initChatSocket();
  }

  Future<void> _initChatSocket() async {
    if (_socketReady) return;
    final chatRepo = serviceLocator<ChatRepository>();
    final connectRes = await chatRepo.connectToUniversalChat();
    if (connectRes is ErrorResponse<void>) return;

    _socketReady = true;
  }

  Future<void> _saveProfile(String fullName) async {
    await serviceLocator<ProfileRepository>().updateProfile(fullName: fullName);
    await _loadDashboard();
  }

  Future<void> _switchAccount(Auth auth) async {
    final uid =
        _firstNonEmptyString(auth.data, ["uid", "user_id", "userId", "id"]);
    if (uid == null || uid.isEmpty) return;
    final res = await serviceLocator<AuthRepository>().switchAccount(uid: uid);
    if (res is ErrorResponse<void>) return;
    await _loadDashboard();
  }

  Future<void> _addAccount() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen(showBack: true)),
    );
    await _loadDashboard();
  }

  Future<void> _logout() async {
    await serviceLocator<AuthRepository>().logout();
  }

  Future<void> _openProfileSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return AccountSwitchSheet(
          profile: _profile,
          accounts: _accounts,
          currentAccountUid: widget.currentAuth.uid,
          onSaveProfile: _saveProfile,
          onSwitchAccount: _switchAccount,
          onAddAccount: _addAccount,
          onLogout: _logout,
        );
      },
    );
    await _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final name = _firstNonEmptyString(
          _profile,
          ["fullName", "name", "userName", "email"],
        ) ??
        widget.currentAuth.userName;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Universal Chat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
          ),
          ProfileAvatarAction(
            label: name,
            onTap: _openProfileSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: UniversalChatModule(
                  senderId:
                      _firstNonEmptyString(
                        _profile,
                        ["user_id", "userId", "uid", "id"],
                      ) ??
                      widget.currentAuth.uid,
                  senderName:
                      _firstNonEmptyString(
                        _profile,
                        ["userName", "fullName", "email", "user_id", "uid"],
                      ) ??
                      widget.currentAuth.userName,
                ),
              ),
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
}
