import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/api_handler/api_response.dart';
import '../../model/chat_message/chat_message.dart';
import '../../model/send_message_param/send_message_param.dart';
import '../../repo/chat_repository.dart';
import 'universal_chat_panel.dart';

class UniversalChatModule extends StatefulWidget {
  const UniversalChatModule({
    super.key,
    required this.senderId,
    required this.senderName,
  });

  final String senderId;
  final String senderName;

  @override
  State<UniversalChatModule> createState() => _UniversalChatModuleState();
}

class _UniversalChatModuleState extends State<UniversalChatModule> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  StreamSubscription<ChatMessage>? _messageSubscription;
  bool _loadingHistory = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    final chatRepo = serviceLocator<ChatRepository>();
    final history = await chatRepo.fetchPreviousMessages();
    if (!mounted) return;
    if (history is SuccessResponse<List<ChatMessage>>) {
      _messages
        ..clear()
        ..addAll(history.data ?? <ChatMessage>[]);
    }
    setState(() => _loadingHistory = false);

    _messageSubscription = chatRepo.messageStream.listen((message) {
      if (!mounted) return;
      setState(() => _messages.add(message));
    });
  }

  void _send() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    serviceLocator<ChatRepository>().sendMessage(
      SendMessageParam(text: text),
      senderId: widget.senderId,
      senderName: widget.senderName,
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }
    return UniversalChatPanel(
      messages: _messages,
      messageController: _messageController,
      onSend: _send,
    );
  }
}
