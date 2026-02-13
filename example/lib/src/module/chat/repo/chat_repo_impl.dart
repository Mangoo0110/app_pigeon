import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/core/constants/api_endpoints.dart';

import '../model/chat_message/chat_message.dart';
import '../model/send_message_param/send_message_param.dart';
import '../model/sender/sender.dart';
import 'chat_repository.dart';

class ChatRepoImpl extends ChatRepository {
  ChatRepoImpl(this._appPigeonResolver);

  final AppPigeon Function() _appPigeonResolver;
  AppPigeon get _appPigeon => _appPigeonResolver();
  static const String _authorizedMessageChannel = 'message';
  static const String _ghostMessageChannel = 'ghost_message';
  bool get _isGhostMode => _appPigeon is GhostAppPigeon;
  String get _messageChannel =>
      _isGhostMode ? _ghostMessageChannel : _authorizedMessageChannel;

  @override
  AsyncRequest<void> connectToUniversalChat({String joinId = 'global_chat'}) {
    return asyncTryCatch(
      tryFunc: () async {
        await _appPigeon.socketInit(
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
  AsyncRequest<List<ChatMessage>> fetchPreviousMessages({int limit = 50}) {
    return asyncTryCatch(
      tryFunc: () async {
        final endpoint = _isGhostMode
            ? ApiEndpoints.ghostChatMessages
            : ApiEndpoints.chatMessages;
        final response = await _appPigeon.get(
          endpoint,
          queryParameters: <String, dynamic>{'limit': limit},
        );
        final body = extractBodyData(response);
        final items = body is List ? body : <dynamic>[];
        final messages = items
            .whereType<Map<String, dynamic>>()
            .map(_parseSocketMessage)
            .toList(growable: false);
        return SuccessResponse<List<ChatMessage>>(
          data: messages,
          message: 'Messages loaded.',
        );
      },
    );
  }

  @override
  Stream<ChatMessage> get messageStream =>
      _appPigeon.listen(_messageChannel).map(_parseSocketMessage);

  @override
  AsyncRequest<void> sendMessage(
    SendMessageParam message, {
    required String senderId,
    required String senderName,
  }) {
    return asyncTryCatch(
      tryFunc: () async {
        final payload = <String, dynamic>{
          ...message.toJson(),
          'message': message.text,
          'sentAt': DateTime.now().toIso8601String(),
          'sender': <String, dynamic>{
            'id': senderId,
            'name': senderName,
          },
        };
        if (_isGhostMode) {
          payload['ghostId'] = senderId;
        }

        _appPigeon.emit(_messageChannel, payload);
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
}
