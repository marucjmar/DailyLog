import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    required String userId,
    required String accessToken,
    required String hostUrl,
  }) = _Session;
}
