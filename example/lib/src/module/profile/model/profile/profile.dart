import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
@JsonSerializable()
class Profile with _$Profile {
  @override
  final String id;
  @override
  final String uid;
  @override
  final String userName;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final bool isVerified;

  const Profile({
    required this.id,
    required this.uid,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.isVerified,
  });

  static Profile get empty => Profile(
        id: '',
        uid: '',
        userName: '',
        fullName: '',
        email: '',
        isVerified: false,
      );

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
