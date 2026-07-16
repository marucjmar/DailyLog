// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionResponseDto _$SessionResponseDtoFromJson(Map<String, dynamic> json) =>
    _SessionResponseDto(
      data: SessionDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionResponseDtoToJson(_SessionResponseDto instance) =>
    <String, dynamic>{'data': instance.data};

_SessionDataDto _$SessionDataDtoFromJson(Map<String, dynamic> json) =>
    _SessionDataDto(
      id: json['id'] as String,
      type: json['type'] as String,
      attributes: SessionAttributesDto.fromJson(
        json['attributes'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SessionDataDtoToJson(_SessionDataDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributes': instance.attributes,
    };

_SessionAttributesDto _$SessionAttributesDtoFromJson(
  Map<String, dynamic> json,
) => _SessionAttributesDto(
  accessToken: json['access_token'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$SessionAttributesDtoToJson(
  _SessionAttributesDto instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'user_id': instance.userId,
};
