// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  id: json['id'] as String,
  uid: json['uid'] as String,
  userName: json['userName'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  isVerified: json['isVerified'] as bool,
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'id': instance.id,
  'uid': instance.uid,
  'userName': instance.userName,
  'fullName': instance.fullName,
  'email': instance.email,
  'isVerified': instance.isVerified,
};
