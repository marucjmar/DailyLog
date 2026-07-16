// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  id: json['id'] as String,
  accessToken: nestedReader(json, 'attributes/access_token') as String,
  userId: nestedReader(json, 'attributes/user_id') as String,
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'id': instance.id,
  'attributes/access_token': instance.accessToken,
  'attributes/user_id': instance.userId,
};
