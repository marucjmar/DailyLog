import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_response.freezed.dart';
part 'session_response.g.dart';

@freezed
abstract class SessionResponseDto with _$SessionResponseDto {
  const factory SessionResponseDto({required SessionDataDto data}) =
      _SessionResponseDto;

  factory SessionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseDtoFromJson(json);
}

@freezed
abstract class SessionDataDto with _$SessionDataDto {
  const factory SessionDataDto({
    required String id,
    required String type,
    required SessionAttributesDto attributes,
  }) = _SessionDataDto;

  factory SessionDataDto.fromJson(Map<String, dynamic> json) =>
      _$SessionDataDtoFromJson(json);
}

@freezed
abstract class SessionAttributesDto with _$SessionAttributesDto {
  const factory SessionAttributesDto({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'user_id') required String userId,
  }) = _SessionAttributesDto;

  factory SessionAttributesDto.fromJson(Map<String, dynamic> json) =>
      _$SessionAttributesDtoFromJson(json);
}
