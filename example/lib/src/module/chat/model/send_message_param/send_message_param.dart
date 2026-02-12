
import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_message_param.freezed.dart';
part 'send_message_param.g.dart';
@freezed
@JsonSerializable()
class SendMessageParam with _$SendMessageParam {
  @override
  final String text;
  SendMessageParam({
    required this.text,
  });

  factory SendMessageParam.fromJson(Map<String, dynamic> json) => _$SendMessageParamFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageParamToJson(this);
}