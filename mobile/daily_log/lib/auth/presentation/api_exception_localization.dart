import 'package:daily_log/auth/data/api/errors.dart';
import 'package:daily_log/auth/l10n/auth_localizations.dart';
import 'package:flutter/material.dart';

extension ApiExceptionLocalization on ApiException {
  String localizedMessage(BuildContext context) {
    final l10n = AuthLocalizations.of(context)!;

    return switch (this) {
      InvalidCredentialsException() =>
        l10n.authInvalidCredentials,

      UnauthorizedException() =>
        l10n.authUnauthorized,

      NetworkException() =>
        l10n.networkError,

      RequestTimeoutException() =>
        l10n.requestTimeout,

      BadCertificateException() =>
        l10n.badCertificate,

      RequestCancelledException() =>
        l10n.requestCancelled,

      BadRequestException() =>
        l10n.badRequest,

      NotFoundException() =>
        l10n.notFound,

      ValidationException(
        code: final code,
        field: final field,
      ) =>
        _validationMessage(
          l10n,
          code: code,
          field: field,
        ),

      ServerException(statusCode: final statusCode) =>
        l10n.serverError(statusCode),

      InvalidResponseException() =>
        l10n.invalidServerResponse,

      UnknownApiException() =>
        l10n.unknownError,
    };
  }
}

String _validationMessage(
  AuthLocalizations l10n, {
  String? code,
  String? field,
}) {
  return switch ((field, code)) {
    ('email', 'invalid') => l10n.emailInvalid,
    ('email', 'required') => l10n.emailRequired,
    ('password', 'required') => l10n.passwordRequired,
    ('password', 'too_short') => l10n.passwordTooShort,
    _ => l10n.validationError,
  };
}