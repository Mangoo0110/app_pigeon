import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
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

  @override
  void initState() {
    super.initState();
    _messageSubscription = serviceLocator<ChatRepository>().messageStream.listen((
      message,
    ) {
      if (!mounted) return;
      setState(() => _messages.add(message));
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _messageController.dispose();
    super.dispose();
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
    return UniversalChatPanel(
      messages: _messages,
      messageController: _messageController,
      onSend: _send,
    );
  }
}
