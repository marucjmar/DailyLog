// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiException {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException()';
}


}

/// @nodoc
class $ApiExceptionCopyWith<$Res>  {
$ApiExceptionCopyWith(ApiException _, $Res Function(ApiException) __);
}


/// Adds pattern-matching-related methods to [ApiException].
extension ApiExceptionPatterns on ApiException {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InvalidCredentialsException value)?  invalidCredentials,TResult Function( UnauthorizedException value)?  unauthorized,TResult Function( NetworkException value)?  network,TResult Function( RequestTimeoutException value)?  timeout,TResult Function( BadCertificateException value)?  badCertificate,TResult Function( RequestCancelledException value)?  cancelled,TResult Function( BadRequestException value)?  badRequest,TResult Function( NotFoundException value)?  notFound,TResult Function( ValidationException value)?  validation,TResult Function( ServerException value)?  server,TResult Function( InvalidResponseException value)?  invalidResponse,TResult Function( UnknownApiException value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InvalidCredentialsException() when invalidCredentials != null:
return invalidCredentials(_that);case UnauthorizedException() when unauthorized != null:
return unauthorized(_that);case NetworkException() when network != null:
return network(_that);case RequestTimeoutException() when timeout != null:
return timeout(_that);case BadCertificateException() when badCertificate != null:
return badCertificate(_that);case RequestCancelledException() when cancelled != null:
return cancelled(_that);case BadRequestException() when badRequest != null:
return badRequest(_that);case NotFoundException() when notFound != null:
return notFound(_that);case ValidationException() when validation != null:
return validation(_that);case ServerException() when server != null:
return server(_that);case InvalidResponseException() when invalidResponse != null:
return invalidResponse(_that);case UnknownApiException() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InvalidCredentialsException value)  invalidCredentials,required TResult Function( UnauthorizedException value)  unauthorized,required TResult Function( NetworkException value)  network,required TResult Function( RequestTimeoutException value)  timeout,required TResult Function( BadCertificateException value)  badCertificate,required TResult Function( RequestCancelledException value)  cancelled,required TResult Function( BadRequestException value)  badRequest,required TResult Function( NotFoundException value)  notFound,required TResult Function( ValidationException value)  validation,required TResult Function( ServerException value)  server,required TResult Function( InvalidResponseException value)  invalidResponse,required TResult Function( UnknownApiException value)  unknown,}){
final _that = this;
switch (_that) {
case InvalidCredentialsException():
return invalidCredentials(_that);case UnauthorizedException():
return unauthorized(_that);case NetworkException():
return network(_that);case RequestTimeoutException():
return timeout(_that);case BadCertificateException():
return badCertificate(_that);case RequestCancelledException():
return cancelled(_that);case BadRequestException():
return badRequest(_that);case NotFoundException():
return notFound(_that);case ValidationException():
return validation(_that);case ServerException():
return server(_that);case InvalidResponseException():
return invalidResponse(_that);case UnknownApiException():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InvalidCredentialsException value)?  invalidCredentials,TResult? Function( UnauthorizedException value)?  unauthorized,TResult? Function( NetworkException value)?  network,TResult? Function( RequestTimeoutException value)?  timeout,TResult? Function( BadCertificateException value)?  badCertificate,TResult? Function( RequestCancelledException value)?  cancelled,TResult? Function( BadRequestException value)?  badRequest,TResult? Function( NotFoundException value)?  notFound,TResult? Function( ValidationException value)?  validation,TResult? Function( ServerException value)?  server,TResult? Function( InvalidResponseException value)?  invalidResponse,TResult? Function( UnknownApiException value)?  unknown,}){
final _that = this;
switch (_that) {
case InvalidCredentialsException() when invalidCredentials != null:
return invalidCredentials(_that);case UnauthorizedException() when unauthorized != null:
return unauthorized(_that);case NetworkException() when network != null:
return network(_that);case RequestTimeoutException() when timeout != null:
return timeout(_that);case BadCertificateException() when badCertificate != null:
return badCertificate(_that);case RequestCancelledException() when cancelled != null:
return cancelled(_that);case BadRequestException() when badRequest != null:
return badRequest(_that);case NotFoundException() when notFound != null:
return notFound(_that);case ValidationException() when validation != null:
return validation(_that);case ServerException() when server != null:
return server(_that);case InvalidResponseException() when invalidResponse != null:
return invalidResponse(_that);case UnknownApiException() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidCredentials,TResult Function()?  unauthorized,TResult Function( Object? cause)?  network,TResult Function( Object? cause)?  timeout,TResult Function( Object? cause)?  badCertificate,TResult Function()?  cancelled,TResult Function( String? code,  String? details)?  badRequest,TResult Function()?  notFound,TResult Function( String? code,  String? field,  String? details)?  validation,TResult Function( int statusCode,  String? code,  String? details)?  server,TResult Function( Object? cause)?  invalidResponse,TResult Function( Object? cause)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InvalidCredentialsException() when invalidCredentials != null:
return invalidCredentials();case UnauthorizedException() when unauthorized != null:
return unauthorized();case NetworkException() when network != null:
return network(_that.cause);case RequestTimeoutException() when timeout != null:
return timeout(_that.cause);case BadCertificateException() when badCertificate != null:
return badCertificate(_that.cause);case RequestCancelledException() when cancelled != null:
return cancelled();case BadRequestException() when badRequest != null:
return badRequest(_that.code,_that.details);case NotFoundException() when notFound != null:
return notFound();case ValidationException() when validation != null:
return validation(_that.code,_that.field,_that.details);case ServerException() when server != null:
return server(_that.statusCode,_that.code,_that.details);case InvalidResponseException() when invalidResponse != null:
return invalidResponse(_that.cause);case UnknownApiException() when unknown != null:
return unknown(_that.cause);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidCredentials,required TResult Function()  unauthorized,required TResult Function( Object? cause)  network,required TResult Function( Object? cause)  timeout,required TResult Function( Object? cause)  badCertificate,required TResult Function()  cancelled,required TResult Function( String? code,  String? details)  badRequest,required TResult Function()  notFound,required TResult Function( String? code,  String? field,  String? details)  validation,required TResult Function( int statusCode,  String? code,  String? details)  server,required TResult Function( Object? cause)  invalidResponse,required TResult Function( Object? cause)  unknown,}) {final _that = this;
switch (_that) {
case InvalidCredentialsException():
return invalidCredentials();case UnauthorizedException():
return unauthorized();case NetworkException():
return network(_that.cause);case RequestTimeoutException():
return timeout(_that.cause);case BadCertificateException():
return badCertificate(_that.cause);case RequestCancelledException():
return cancelled();case BadRequestException():
return badRequest(_that.code,_that.details);case NotFoundException():
return notFound();case ValidationException():
return validation(_that.code,_that.field,_that.details);case ServerException():
return server(_that.statusCode,_that.code,_that.details);case InvalidResponseException():
return invalidResponse(_that.cause);case UnknownApiException():
return unknown(_that.cause);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidCredentials,TResult? Function()?  unauthorized,TResult? Function( Object? cause)?  network,TResult? Function( Object? cause)?  timeout,TResult? Function( Object? cause)?  badCertificate,TResult? Function()?  cancelled,TResult? Function( String? code,  String? details)?  badRequest,TResult? Function()?  notFound,TResult? Function( String? code,  String? field,  String? details)?  validation,TResult? Function( int statusCode,  String? code,  String? details)?  server,TResult? Function( Object? cause)?  invalidResponse,TResult? Function( Object? cause)?  unknown,}) {final _that = this;
switch (_that) {
case InvalidCredentialsException() when invalidCredentials != null:
return invalidCredentials();case UnauthorizedException() when unauthorized != null:
return unauthorized();case NetworkException() when network != null:
return network(_that.cause);case RequestTimeoutException() when timeout != null:
return timeout(_that.cause);case BadCertificateException() when badCertificate != null:
return badCertificate(_that.cause);case RequestCancelledException() when cancelled != null:
return cancelled();case BadRequestException() when badRequest != null:
return badRequest(_that.code,_that.details);case NotFoundException() when notFound != null:
return notFound();case ValidationException() when validation != null:
return validation(_that.code,_that.field,_that.details);case ServerException() when server != null:
return server(_that.statusCode,_that.code,_that.details);case InvalidResponseException() when invalidResponse != null:
return invalidResponse(_that.cause);case UnknownApiException() when unknown != null:
return unknown(_that.cause);case _:
  return null;

}
}

}

/// @nodoc


class InvalidCredentialsException implements ApiException {
  const InvalidCredentialsException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidCredentialsException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException.invalidCredentials()';
}


}




/// @nodoc


class UnauthorizedException implements ApiException {
  const UnauthorizedException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException.unauthorized()';
}


}




/// @nodoc


class NetworkException implements ApiException {
  const NetworkException({this.cause});
  

 final  Object? cause;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkExceptionCopyWith<NetworkException> get copyWith => _$NetworkExceptionCopyWithImpl<NetworkException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkException&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'ApiException.network(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $NetworkExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $NetworkExceptionCopyWith(NetworkException value, $Res Function(NetworkException) _then) = _$NetworkExceptionCopyWithImpl;
@useResult
$Res call({
 Object? cause
});




}
/// @nodoc
class _$NetworkExceptionCopyWithImpl<$Res>
    implements $NetworkExceptionCopyWith<$Res> {
  _$NetworkExceptionCopyWithImpl(this._self, this._then);

  final NetworkException _self;
  final $Res Function(NetworkException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cause = freezed,}) {
  return _then(NetworkException(
cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class RequestTimeoutException implements ApiException {
  const RequestTimeoutException({this.cause});
  

 final  Object? cause;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestTimeoutExceptionCopyWith<RequestTimeoutException> get copyWith => _$RequestTimeoutExceptionCopyWithImpl<RequestTimeoutException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestTimeoutException&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'ApiException.timeout(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $RequestTimeoutExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $RequestTimeoutExceptionCopyWith(RequestTimeoutException value, $Res Function(RequestTimeoutException) _then) = _$RequestTimeoutExceptionCopyWithImpl;
@useResult
$Res call({
 Object? cause
});




}
/// @nodoc
class _$RequestTimeoutExceptionCopyWithImpl<$Res>
    implements $RequestTimeoutExceptionCopyWith<$Res> {
  _$RequestTimeoutExceptionCopyWithImpl(this._self, this._then);

  final RequestTimeoutException _self;
  final $Res Function(RequestTimeoutException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cause = freezed,}) {
  return _then(RequestTimeoutException(
cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class BadCertificateException implements ApiException {
  const BadCertificateException({this.cause});
  

 final  Object? cause;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadCertificateExceptionCopyWith<BadCertificateException> get copyWith => _$BadCertificateExceptionCopyWithImpl<BadCertificateException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadCertificateException&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'ApiException.badCertificate(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $BadCertificateExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $BadCertificateExceptionCopyWith(BadCertificateException value, $Res Function(BadCertificateException) _then) = _$BadCertificateExceptionCopyWithImpl;
@useResult
$Res call({
 Object? cause
});




}
/// @nodoc
class _$BadCertificateExceptionCopyWithImpl<$Res>
    implements $BadCertificateExceptionCopyWith<$Res> {
  _$BadCertificateExceptionCopyWithImpl(this._self, this._then);

  final BadCertificateException _self;
  final $Res Function(BadCertificateException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cause = freezed,}) {
  return _then(BadCertificateException(
cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class RequestCancelledException implements ApiException {
  const RequestCancelledException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestCancelledException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException.cancelled()';
}


}




/// @nodoc


class BadRequestException implements ApiException {
  const BadRequestException({this.code, this.details});
  

 final  String? code;
 final  String? details;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadRequestExceptionCopyWith<BadRequestException> get copyWith => _$BadRequestExceptionCopyWithImpl<BadRequestException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadRequestException&&(identical(other.code, code) || other.code == code)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,code,details);

@override
String toString() {
  return 'ApiException.badRequest(code: $code, details: $details)';
}


}

/// @nodoc
abstract mixin class $BadRequestExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $BadRequestExceptionCopyWith(BadRequestException value, $Res Function(BadRequestException) _then) = _$BadRequestExceptionCopyWithImpl;
@useResult
$Res call({
 String? code, String? details
});




}
/// @nodoc
class _$BadRequestExceptionCopyWithImpl<$Res>
    implements $BadRequestExceptionCopyWith<$Res> {
  _$BadRequestExceptionCopyWithImpl(this._self, this._then);

  final BadRequestException _self;
  final $Res Function(BadRequestException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? details = freezed,}) {
  return _then(BadRequestException(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NotFoundException implements ApiException {
  const NotFoundException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException.notFound()';
}


}




/// @nodoc


class ValidationException implements ApiException {
  const ValidationException({this.code, this.field, this.details});
  

 final  String? code;
 final  String? field;
 final  String? details;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationExceptionCopyWith<ValidationException> get copyWith => _$ValidationExceptionCopyWithImpl<ValidationException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationException&&(identical(other.code, code) || other.code == code)&&(identical(other.field, field) || other.field == field)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,code,field,details);

@override
String toString() {
  return 'ApiException.validation(code: $code, field: $field, details: $details)';
}


}

/// @nodoc
abstract mixin class $ValidationExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $ValidationExceptionCopyWith(ValidationException value, $Res Function(ValidationException) _then) = _$ValidationExceptionCopyWithImpl;
@useResult
$Res call({
 String? code, String? field, String? details
});




}
/// @nodoc
class _$ValidationExceptionCopyWithImpl<$Res>
    implements $ValidationExceptionCopyWith<$Res> {
  _$ValidationExceptionCopyWithImpl(this._self, this._then);

  final ValidationException _self;
  final $Res Function(ValidationException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? field = freezed,Object? details = freezed,}) {
  return _then(ValidationException(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServerException implements ApiException {
  const ServerException({required this.statusCode, this.code, this.details});
  

 final  int statusCode;
 final  String? code;
 final  String? details;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerExceptionCopyWith<ServerException> get copyWith => _$ServerExceptionCopyWithImpl<ServerException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerException&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.code, code) || other.code == code)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode,code,details);

@override
String toString() {
  return 'ApiException.server(statusCode: $statusCode, code: $code, details: $details)';
}


}

/// @nodoc
abstract mixin class $ServerExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $ServerExceptionCopyWith(ServerException value, $Res Function(ServerException) _then) = _$ServerExceptionCopyWithImpl;
@useResult
$Res call({
 int statusCode, String? code, String? details
});




}
/// @nodoc
class _$ServerExceptionCopyWithImpl<$Res>
    implements $ServerExceptionCopyWith<$Res> {
  _$ServerExceptionCopyWithImpl(this._self, this._then);

  final ServerException _self;
  final $Res Function(ServerException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = null,Object? code = freezed,Object? details = freezed,}) {
  return _then(ServerException(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class InvalidResponseException implements ApiException {
  const InvalidResponseException({this.cause});
  

 final  Object? cause;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvalidResponseExceptionCopyWith<InvalidResponseException> get copyWith => _$InvalidResponseExceptionCopyWithImpl<InvalidResponseException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidResponseException&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'ApiException.invalidResponse(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $InvalidResponseExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $InvalidResponseExceptionCopyWith(InvalidResponseException value, $Res Function(InvalidResponseException) _then) = _$InvalidResponseExceptionCopyWithImpl;
@useResult
$Res call({
 Object? cause
});




}
/// @nodoc
class _$InvalidResponseExceptionCopyWithImpl<$Res>
    implements $InvalidResponseExceptionCopyWith<$Res> {
  _$InvalidResponseExceptionCopyWithImpl(this._self, this._then);

  final InvalidResponseException _self;
  final $Res Function(InvalidResponseException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cause = freezed,}) {
  return _then(InvalidResponseException(
cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class UnknownApiException implements ApiException {
  const UnknownApiException({this.cause});
  

 final  Object? cause;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownApiExceptionCopyWith<UnknownApiException> get copyWith => _$UnknownApiExceptionCopyWithImpl<UnknownApiException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownApiException&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'ApiException.unknown(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $UnknownApiExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $UnknownApiExceptionCopyWith(UnknownApiException value, $Res Function(UnknownApiException) _then) = _$UnknownApiExceptionCopyWithImpl;
@useResult
$Res call({
 Object? cause
});




}
/// @nodoc
class _$UnknownApiExceptionCopyWithImpl<$Res>
    implements $UnknownApiExceptionCopyWith<$Res> {
  _$UnknownApiExceptionCopyWithImpl(this._self, this._then);

  final UnknownApiException _self;
  final $Res Function(UnknownApiException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cause = freezed,}) {
  return _then(UnknownApiException(
cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

// dart format on
