// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  sender: Sender.fromJson(json['sender'] as Map<String, dynamic>),
  text: json['text'] as String,
  sentAt: DateTime.parse(json['sentAt'] as String),
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'text': instance.text,
      'sentAt': instance.sentAt.toIso8601String(),
    };
