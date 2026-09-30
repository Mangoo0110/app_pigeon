import 'package:freezed_annotation/freezed_annotation.dart';

part 'sender.freezed.dart';
part 'sender.g.dart';

@freezed
@JsonSerializable()
class Sender with _$Sender {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? profileImage;

  const Sender({required this.id, required this.name, this.profileImage});

  factory Sender.fromJson(Map<String, dynamic> json) => _$SenderFromJson(json);
}
