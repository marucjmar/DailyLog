import 'package:daily_log/auth/data/api/errors.dart';
import 'package:daily_log/auth/l10n/auth_localizations.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

extension ApiExceptionLocalization on ApiException {
  String localizedMessage(BuildContext context) {
    final l10n = AuthLocalizations.of(context)!;
    final l10nValidator = FormBuilderLocalizations.of(context)!;

    return switch (this) {
      InvalidCredentialsException() => l10n.authInvalidCredentials,

      UnauthorizedException() => l10n.authUnauthorized,

      NetworkException() => l10n.networkError,

      RequestTimeoutException() => l10n.requestTimeout,

      BadCertificateException() => l10n.badCertificate,

      RequestCancelledException() => l10n.requestCancelled,

      BadRequestException() => l10n.badRequest,

      NotFoundException() => l10n.notFound,

      ValidationException(code: final code, field: final field) =>
        _validationMessage(l10n, l10nValidator, code: code, field: field),

      ServerException(statusCode: final statusCode) => l10n.serverError(
        statusCode,
      ),

      InvalidResponseException() => l10n.invalidServerResponse,

      UnknownApiException() => l10n.unknownError,
    };
  }
}

String _validationMessage(
  AuthLocalizations l10n,
  FormBuilderLocalizationsImpl l10nValidator, {
  String? code,
  String? field,
}) {
  return switch ((field, code)) {
    ('email', 'invalid') => l10nValidator.emailErrorText,
    ('email', 'required') => l10nValidator.requiredErrorText,
    ('password', 'required') => l10nValidator.requiredErrorText,
    ('password', 'too_short') => l10nValidator.minLengthErrorText(1),
    _ => l10n.validationError,
  };
}
