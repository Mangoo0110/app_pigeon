import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';

import '../../app/routing/app_router.dart';
import '../../app/routing/route_names.dart';
import '../../core/api_handler/api_response.dart';
import '../../core/di/service_locator.dart';
import '../../module/auth/model/authenticated_user.dart';
import '../../module/auth/presentation/screen/login_screen.dart';
import '../../module/auth/repo/auth_repository.dart';
import '../../module/chat/presentation/widget/universal_chat_module.dart';
import '../../module/chat/repo/chat_repository.dart';
import '../../module/profile/model/profile/profile.dart';
import '../../module/profile/model/update_profile_request/update_profile_request.dart';
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
  Profile _profile = Profile.empty;
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

    if (widget.currentAuth.isGuest) {
      _accounts = const <Auth>[];
      _profile = Profile(
        id: widget.currentAuth.uid,
        uid: widget.currentAuth.uid,
        userName: widget.currentAuth.userName,
        fullName: widget.currentAuth.userName,
        email: '',
        isVerified: true,
      );
      setState(() => _loading = false);
      await _initChatSocket();
      return;
    }

    final authRepo = serviceLocator<AuthRepository>();
    final profileRepo = serviceLocator<ProfileRepository>();

    final accountsRes = await authRepo.fetchAllAccounts();
    final profileRes = await profileRepo.fetchProfile();

    final accounts = accountsRes is SuccessResponse<List<Auth>>
        ? (accountsRes.data ?? <Auth>[])
        : <Auth>[];
    final profile = profileRes is SuccessResponse<Profile>
        ? (profileRes.data ?? Profile.empty)
        : Profile.empty;

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
    await serviceLocator<ProfileRepository>().updateProfile(
      UpdateProfileRequest(fullName: fullName),
    );
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

  Future<void> _goToLoginFromGuest() async {
    ghostPigeon.disconnectSocket();
    serviceLocator<ActivePigeonResolver>().useGhost();
    await AppRouter.navigateToReplacement(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile.fullName.isNotEmpty
        ? _profile.fullName
        : (_profile.userName.isNotEmpty
              ? _profile.userName
              : widget.currentAuth.userName);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Universal Chat"),
        actions: widget.currentAuth.isGuest
            ? [
                TextButton.icon(
                  onPressed: _goToLoginFromGuest,
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                ),
              ]
            : [
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
                  senderId: _profile.uid.isNotEmpty
                      ? _profile.uid
                      : widget.currentAuth.uid,
                  senderName: _profile.userName.isNotEmpty
                      ? _profile.userName
                      : widget.currentAuth.userName,
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
