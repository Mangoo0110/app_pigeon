import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/core/constants/api_endpoints.dart';

import '../model/chat_message/chat_message.dart';
import '../model/send_message_param/send_message_param.dart';
import '../model/sender/sender.dart';
import 'chat_repository.dart';

class ChatRepoImpl extends ChatRepository {
  ChatRepoImpl(this.appPigeon);

  final AppPigeon appPigeon;
  static const String _messageChannel = 'message';

  @override
  AsyncRequest<void> connectToUniversalChat({String joinId = 'global_chat'}) {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.socketInit(
          SocketConnetParamX(
            token: null,
            socketUrl: ApiEndpoints.socketUrl,
            joinId: joinId,
          ),
        );
        return SuccessResponse<void>(
          data: null,
          message: 'Connected to universal chat.',
        );
      },
    );
  }

  @override
  Stream<ChatMessage> get messageStream =>
      appPigeon.listen(_messageChannel).map(_parseSocketMessage);

  @override
  AsyncRequest<void> sendMessage(SendMessageParam message) {
    return asyncTryCatch(
      tryFunc: () async {
        appPigeon.emit(_messageChannel, message.toJson());
        return SuccessResponse<void>(
          data: null,
          message: 'Message sent.',
        );
      },
    );
  }

  ChatMessage _parseSocketMessage(dynamic event) {
    if (event is Map<String, dynamic>) {
      final rawSender = event['sender'];
      final sender = _parseSender(rawSender);
      final text =
          event['text']?.toString() ?? event['message']?.toString() ?? '';
      final sentAt = DateTime.tryParse(event['sentAt']?.toString() ?? '');

      return ChatMessage(
        sender: sender,
        text: text,
        sentAt: sentAt ?? DateTime.now(),
      );
    }

    return ChatMessage(
      sender: const Sender(id: 'unknown', name: 'Unknown'),
      text: event?.toString() ?? '',
      sentAt: DateTime.now(),
    );
  }

  Sender _parseSender(dynamic rawSender) {
    if (rawSender is Map<String, dynamic>) {
      return Sender.fromJson(rawSender);
    }

    final name = rawSender?.toString().trim();
    if (name != null && name.isNotEmpty) {
      return Sender(id: 'unknown', name: name);
    }

    return const Sender(id: 'unknown', name: 'Unknown');
  }

  Map<String, dynamic> _buildPayload(ChatMessage message) {
    return <String, dynamic>{
      'message': message.text,
      'text': message.text,
      'sender': <String, dynamic>{
        'id': message.sender.id,
        'name': message.sender.name,
        'profileImage': message.sender.profileImage,
      },
      'sentAt': message.sentAt.toIso8601String(),
    };
  }
}
