// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['userId', 'name', 'role', 'access_token'],
  );
  return User(
    userId: json['userId'] as String,
    username: json['name'] as String,
    accessToken: json['access_token'] as String,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.username,
      'role': instance.role,
      'access_token': instance.accessToken,
    };
