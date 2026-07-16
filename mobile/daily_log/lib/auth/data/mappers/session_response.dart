import 'package:daily_log/auth/data/dto/session_response.dart';
import 'package:daily_log/auth/domain/models/session.dart';

extension SessionResponseDtoMapper on SessionResponseDto {
  Session toDomain({
    required String hostUrl,
  }) {
    return Session(
      id: data.id,
      userId: data.attributes.userId,
      accessToken: data.attributes.accessToken,
      hostUrl: hostUrl,
    );
  }
}
