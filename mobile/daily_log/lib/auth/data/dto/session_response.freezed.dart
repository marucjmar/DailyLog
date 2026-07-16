// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionResponseDto {

 SessionDataDto get data;
/// Create a copy of SessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionResponseDtoCopyWith<SessionResponseDto> get copyWith => _$SessionResponseDtoCopyWithImpl<SessionResponseDto>(this as SessionResponseDto, _$identity);

  /// Serializes this SessionResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'SessionResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $SessionResponseDtoCopyWith<$Res>  {
  factory $SessionResponseDtoCopyWith(SessionResponseDto value, $Res Function(SessionResponseDto) _then) = _$SessionResponseDtoCopyWithImpl;
@useResult
$Res call({
 SessionDataDto data
});


$SessionDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$SessionResponseDtoCopyWithImpl<$Res>
    implements $SessionResponseDtoCopyWith<$Res> {
  _$SessionResponseDtoCopyWithImpl(this._self, this._then);

  final SessionResponseDto _self;
  final $Res Function(SessionResponseDto) _then;

/// Create a copy of SessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(SessionResponseDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SessionDataDto,
  ));
}
/// Create a copy of SessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionDataDtoCopyWith<$Res> get data {
  
  return $SessionDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionResponseDto].
extension SessionResponseDtoPatterns on SessionResponseDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionResponseDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SessionResponseDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SessionResponseDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionDataDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionResponseDto() when $default != null:
return $default(_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionDataDto data)  $default,) {final _that = this;
switch (_that) {
case _SessionResponseDto():
return $default(_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionDataDto data)?  $default,) {final _that = this;
switch (_that) {
case _SessionResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionResponseDto implements SessionResponseDto {
  const _SessionResponseDto({required this.data});
  factory _SessionResponseDto.fromJson(Map<String, dynamic> json) => _$SessionResponseDtoFromJson(json);

@override final  SessionDataDto data;

/// Create a copy of SessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionResponseDtoCopyWith<_SessionResponseDto> get copyWith => __$SessionResponseDtoCopyWithImpl<_SessionResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'SessionResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$SessionResponseDtoCopyWith<$Res> implements $SessionResponseDtoCopyWith<$Res> {
  factory _$SessionResponseDtoCopyWith(_SessionResponseDto value, $Res Function(_SessionResponseDto) _then) = __$SessionResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 SessionDataDto data
});


@override $SessionDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$SessionResponseDtoCopyWithImpl<$Res>
    implements _$SessionResponseDtoCopyWith<$Res> {
  __$SessionResponseDtoCopyWithImpl(this._self, this._then);

  final _SessionResponseDto _self;
  final $Res Function(_SessionResponseDto) _then;

/// Create a copy of SessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_SessionResponseDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SessionDataDto,
  ));
}

/// Create a copy of SessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionDataDtoCopyWith<$Res> get data {
  
  return $SessionDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$SessionDataDto {

 String get id; String get type; SessionAttributesDto get attributes;
/// Create a copy of SessionDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionDataDtoCopyWith<SessionDataDto> get copyWith => _$SessionDataDtoCopyWithImpl<SessionDataDto>(this as SessionDataDto, _$identity);

  /// Serializes this SessionDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDataDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.attributes, attributes) || other.attributes == attributes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,attributes);

@override
String toString() {
  return 'SessionDataDto(id: $id, type: $type, attributes: $attributes)';
}


}

/// @nodoc
abstract mixin class $SessionDataDtoCopyWith<$Res>  {
  factory $SessionDataDtoCopyWith(SessionDataDto value, $Res Function(SessionDataDto) _then) = _$SessionDataDtoCopyWithImpl;
@useResult
$Res call({
 String id, String type, SessionAttributesDto attributes
});


$SessionAttributesDtoCopyWith<$Res> get attributes;

}
/// @nodoc
class _$SessionDataDtoCopyWithImpl<$Res>
    implements $SessionDataDtoCopyWith<$Res> {
  _$SessionDataDtoCopyWithImpl(this._self, this._then);

  final SessionDataDto _self;
  final $Res Function(SessionDataDto) _then;

/// Create a copy of SessionDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? attributes = null,}) {
  return _then(SessionDataDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as SessionAttributesDto,
  ));
}
/// Create a copy of SessionDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionAttributesDtoCopyWith<$Res> get attributes {
  
  return $SessionAttributesDtoCopyWith<$Res>(_self.attributes, (value) {
    return _then(_self.copyWith(attributes: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionDataDto].
extension SessionDataDtoPatterns on SessionDataDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionDataDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionDataDto value)  $default,){
final _that = this;
switch (_that) {
case _SessionDataDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _SessionDataDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  SessionAttributesDto attributes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionDataDto() when $default != null:
return $default(_that.id,_that.type,_that.attributes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  SessionAttributesDto attributes)  $default,) {final _that = this;
switch (_that) {
case _SessionDataDto():
return $default(_that.id,_that.type,_that.attributes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  SessionAttributesDto attributes)?  $default,) {final _that = this;
switch (_that) {
case _SessionDataDto() when $default != null:
return $default(_that.id,_that.type,_that.attributes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionDataDto implements SessionDataDto {
  const _SessionDataDto({required this.id, required this.type, required this.attributes});
  factory _SessionDataDto.fromJson(Map<String, dynamic> json) => _$SessionDataDtoFromJson(json);

@override final  String id;
@override final  String type;
@override final  SessionAttributesDto attributes;

/// Create a copy of SessionDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionDataDtoCopyWith<_SessionDataDto> get copyWith => __$SessionDataDtoCopyWithImpl<_SessionDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionDataDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.attributes, attributes) || other.attributes == attributes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,attributes);

@override
String toString() {
  return 'SessionDataDto(id: $id, type: $type, attributes: $attributes)';
}


}

/// @nodoc
abstract mixin class _$SessionDataDtoCopyWith<$Res> implements $SessionDataDtoCopyWith<$Res> {
  factory _$SessionDataDtoCopyWith(_SessionDataDto value, $Res Function(_SessionDataDto) _then) = __$SessionDataDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, SessionAttributesDto attributes
});


@override $SessionAttributesDtoCopyWith<$Res> get attributes;

}
/// @nodoc
class __$SessionDataDtoCopyWithImpl<$Res>
    implements _$SessionDataDtoCopyWith<$Res> {
  __$SessionDataDtoCopyWithImpl(this._self, this._then);

  final _SessionDataDto _self;
  final $Res Function(_SessionDataDto) _then;

/// Create a copy of SessionDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? attributes = null,}) {
  return _then(_SessionDataDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as SessionAttributesDto,
  ));
}

/// Create a copy of SessionDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionAttributesDtoCopyWith<$Res> get attributes {
  
  return $SessionAttributesDtoCopyWith<$Res>(_self.attributes, (value) {
    return _then(_self.copyWith(attributes: value));
  });
}
}


/// @nodoc
mixin _$SessionAttributesDto {

@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'user_id') String get userId;
/// Create a copy of SessionAttributesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionAttributesDtoCopyWith<SessionAttributesDto> get copyWith => _$SessionAttributesDtoCopyWithImpl<SessionAttributesDto>(this as SessionAttributesDto, _$identity);

  /// Serializes this SessionAttributesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionAttributesDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,userId);

@override
String toString() {
  return 'SessionAttributesDto(accessToken: $accessToken, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $SessionAttributesDtoCopyWith<$Res>  {
  factory $SessionAttributesDtoCopyWith(SessionAttributesDto value, $Res Function(SessionAttributesDto) _then) = _$SessionAttributesDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'user_id') String userId
});




}
/// @nodoc
class _$SessionAttributesDtoCopyWithImpl<$Res>
    implements $SessionAttributesDtoCopyWith<$Res> {
  _$SessionAttributesDtoCopyWithImpl(this._self, this._then);

  final SessionAttributesDto _self;
  final $Res Function(SessionAttributesDto) _then;

/// Create a copy of SessionAttributesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? userId = null,}) {
  return _then(SessionAttributesDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionAttributesDto].
extension SessionAttributesDtoPatterns on SessionAttributesDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionAttributesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionAttributesDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionAttributesDto value)  $default,){
final _that = this;
switch (_that) {
case _SessionAttributesDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionAttributesDto value)?  $default,){
final _that = this;
switch (_that) {
case _SessionAttributesDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'user_id')  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionAttributesDto() when $default != null:
return $default(_that.accessToken,_that.userId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'user_id')  String userId)  $default,) {final _that = this;
switch (_that) {
case _SessionAttributesDto():
return $default(_that.accessToken,_that.userId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'user_id')  String userId)?  $default,) {final _that = this;
switch (_that) {
case _SessionAttributesDto() when $default != null:
return $default(_that.accessToken,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionAttributesDto implements SessionAttributesDto {
  const _SessionAttributesDto({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'user_id') required this.userId});
  factory _SessionAttributesDto.fromJson(Map<String, dynamic> json) => _$SessionAttributesDtoFromJson(json);

@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'user_id') final  String userId;

/// Create a copy of SessionAttributesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionAttributesDtoCopyWith<_SessionAttributesDto> get copyWith => __$SessionAttributesDtoCopyWithImpl<_SessionAttributesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionAttributesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionAttributesDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,userId);

@override
String toString() {
  return 'SessionAttributesDto(accessToken: $accessToken, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$SessionAttributesDtoCopyWith<$Res> implements $SessionAttributesDtoCopyWith<$Res> {
  factory _$SessionAttributesDtoCopyWith(_SessionAttributesDto value, $Res Function(_SessionAttributesDto) _then) = __$SessionAttributesDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'user_id') String userId
});




}
/// @nodoc
class __$SessionAttributesDtoCopyWithImpl<$Res>
    implements _$SessionAttributesDtoCopyWith<$Res> {
  __$SessionAttributesDtoCopyWithImpl(this._self, this._then);

  final _SessionAttributesDto _self;
  final $Res Function(_SessionAttributesDto) _then;

/// Create a copy of SessionAttributesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? userId = null,}) {
  return _then(_SessionAttributesDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
