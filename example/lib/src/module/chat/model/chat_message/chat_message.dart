import 'package:freezed_annotation/freezed_annotation.dart';

import '../sender/sender.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
@JsonSerializable()
class ChatMessage with _$ChatMessage {
  @override
  @JsonKey(fromJson: Sender.fromJson)
  final Sender sender;
  @override
  final String text;
  @override
  final DateTime sentAt;

  ChatMessage({required this.sender, required this.text, required this.sentAt});

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
