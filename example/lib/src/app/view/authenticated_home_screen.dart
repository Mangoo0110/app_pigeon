import 'dart:async';

import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/module/chat/model/send_message_param/send_message_param.dart';
import 'package:flutter/material.dart';

import '../../core/api_handler/api_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/di/service_locator.dart';
import '../../module/auth/model/authenticated_user.dart';
import '../../module/auth/presentation/screen/login_screen.dart';
import '../../module/auth/repo/auth_repository.dart';
import '../../module/chat/model/chat_message/chat_message.dart';
import '../../module/chat/model/sender/sender.dart';
import '../../module/chat/presentation/widget/universal_chat_panel.dart';
import '../../module/chat/repo/chat_repository.dart';
import '../../module/profile/presentation/widget/account_switch_sheet.dart';
import '../../module/profile/presentation/widget/profile_avatar_action.dart';

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
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  StreamSubscription<ChatMessage>? _messageSubscription;
  Map<String, dynamic> _profile = <String, dynamic>{};
  List<Auth> _accounts = <Auth>[];
  Auth? _currentAuthRecord;
  bool _loading = true;
  bool _socketReady = false;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    if (!mounted) return;
    setState(() => _loading = true);

    final appPigeon = serviceLocator<AppPigeon>();
    final current = await appPigeon.getCurrentAuthRecord();
    final accounts = await appPigeon.getAllAuthRecords();

    Map<String, dynamic> profile = <String, dynamic>{};
    try {
      final response = await appPigeon.get(ApiEndpoints.userProfile);
      final data = response.data["data"];
      if (data is Map<String, dynamic>) {
        profile = Map<String, dynamic>.from(data);
      }
    } catch (_) {}

    if (!mounted) return;
    _currentAuthRecord = current;
    _accounts = accounts;
    _profile = profile;
    setState(() => _loading = false);

    await _initChatSocket();
  }

  Future<void> _initChatSocket() async {
    if (_socketReady) return;
    final chatRepo = serviceLocator<ChatRepository>();
    final connectRes = await chatRepo.connectToUniversalChat();
    if (connectRes is ErrorResponse<void>) return;

    _messageSubscription = chatRepo.messageStream.listen((message) {
      if (!mounted) return;
      setState(() => _messages.add(message));
    });
    _socketReady = true;
  }

  Future<void> _saveProfile(String fullName) async {
    await serviceLocator<AppPigeon>().patch(
      ApiEndpoints.userProfile,
      data: <String, dynamic>{"fullName": fullName},
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

  void _sendChatMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final sender = _firstNonEmptyString(
          _profile,
          ["userName", "fullName", "email", "user_id", "uid"],
        ) ??
        widget.currentAuth.userName;
    final senderId = _firstNonEmptyString(
          _profile,
          ["user_id", "userId", "uid", "id"],
        ) ??
        widget.currentAuth.uid;
    final message = ChatMessage(
      sender: Sender(id: senderId, name: sender),
      text: text,
      sentAt: DateTime.now(),
    );
    serviceLocator<ChatRepository>().sendMessage(SendMessageParam(text: text));
    _messageController.clear();
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
          currentAccountUid: _currentAuthRecord == null
              ? null
              : _firstNonEmptyString(
                  _currentAuthRecord!.data,
                  ["uid", "user_id", "userId", "id"],
                ),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: UniversalChatPanel(
                messages: _messages,
                messageController: _messageController,
                onSend: _sendChatMessage,
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
