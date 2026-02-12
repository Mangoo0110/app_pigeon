import 'package:flutter/material.dart';

import '../../model/chat_message/chat_message.dart';

class UniversalChatPanel extends StatelessWidget {
  const UniversalChatPanel({
    super.key,
    required this.messages,
    required this.messageController,
    required this.onSend,
  });

  final List<ChatMessage> messages;
  final TextEditingController messageController;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Global chat", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: messages.isEmpty
                ? const Center(child: Text("No messages yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text("${message.sender.name}: ${message.text}"),
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onSend,
              child: const Text("Send"),
            ),
          ],
        ),
      ],
    );
  }
}
