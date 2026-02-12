import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';
import 'package:example/src/module/chat/model/send_message_param/send_message_param.dart';

import '../model/chat_message/chat_message.dart';

abstract class ChatRepository with ErrorHandler {
  AsyncRequest<void> connectToUniversalChat({String joinId = 'global_chat'});
  Stream<ChatMessage> get messageStream;
  AsyncRequest<void> sendMessage(SendMessageParam message);
}

class ChatRepositoryStub extends ChatRepository {
  ApiResponse<T> _notImplemented<T>(String feature) {
    return ErrorResponse(
      message: '$feature is not implemented yet.',
      exception: Exception('Not implemented'),
      stackTrace: StackTrace.current,
    );
  }

  @override
  AsyncRequest<void> connectToUniversalChat({String joinId = 'global_chat'}) {
    return Future<ApiResponse<void>>.value(_notImplemented('Connect chat'));
  }

  @override
  Stream<ChatMessage> get messageStream => const Stream<ChatMessage>.empty();

  @override
  AsyncRequest<void> sendMessage(SendMessageParam message) {
    return Future<ApiResponse<void>>.value(_notImplemented('Send message'));
  }
}
