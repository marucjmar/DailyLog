import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

Object? nestedReader(Map json, String key) {
  final keys = key.split('/');
  return _nestedReader(json, keys);
}

Object? _nestedReader(final Object? object, Iterable<String> keys) {
  if (keys.isEmpty || object == null) {
    return object;
  }
  if (object is Map) {
    final subObject = object[keys.first];
    final subKeys = keys.skip(1);
    return _nestedReader(subObject, subKeys);
  }
  if (object is List) {
    return object.fold<dynamic>([], (list, subObject) {
      return list..add(_nestedReader(subObject, keys));
    });
  }
  return object;
}

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    @JsonKey(name: 'attributes/access_token', readValue: nestedReader) required String accessToken,
    @JsonKey(name: 'attributes/user_id', readValue: nestedReader) required String userId,
  }) = _Session;
  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}
