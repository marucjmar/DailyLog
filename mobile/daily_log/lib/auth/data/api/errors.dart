import 'package:freezed_annotation/freezed_annotation.dart';

part 'errors.freezed.dart';

@freezed
sealed class ApiException with _$ApiException implements Exception {
  const factory ApiException.invalidCredentials() = InvalidCredentialsException;

  const factory ApiException.unauthorized() = UnauthorizedException;

  const factory ApiException.network({Object? cause}) = NetworkException;

  const factory ApiException.timeout({Object? cause}) = RequestTimeoutException;

  const factory ApiException.badCertificate({Object? cause}) =
      BadCertificateException;

  const factory ApiException.cancelled() = RequestCancelledException;

  const factory ApiException.badRequest({String? code, String? details}) =
      BadRequestException;

  const factory ApiException.notFound() = NotFoundException;

  const factory ApiException.validation({
    String? code,
    String? field,
    String? details,
  }) = ValidationException;

  const factory ApiException.server({
    required int statusCode,
    String? code,
    String? details,
  }) = ServerException;

  const factory ApiException.invalidResponse({Object? cause}) =
      InvalidResponseException;

  const factory ApiException.unknown({Object? cause}) = UnknownApiException;
}
