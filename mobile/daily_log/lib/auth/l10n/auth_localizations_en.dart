// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AuthLocalizationsEn extends AuthLocalizations {
  AuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authInvalidCredentials => 'Invalid email or password';

  @override
  String get authUnauthorized => 'You are not authorized to perform this action';

  @override
  String get networkError => 'Could not connect to the server';

  @override
  String get requestTimeout => 'The server did not respond in time';

  @override
  String get badCertificate => 'The server certificate could not be verified';

  @override
  String get requestCancelled => 'The request was cancelled';

  @override
  String get badRequest => 'The request is invalid';

  @override
  String get notFound => 'The requested resource was not found';

  @override
  String get invalidServerResponse => 'The server returned an invalid response';

  @override
  String serverError(int statusCode) {
    return 'Server error ($statusCode)';
  }

  @override
  String get validationError => 'The submitted data is invalid';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get emailRequired => 'Enter your email address';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get passwordTooShort => 'The password is too short';

  @override
  String get unknownError => 'An unexpected error occurred';

  @override
  String get loginView_Title => 'Sign In';

  @override
  String get loginView_formSubmit => 'Login';

  @override
  String get loginView_serverHostField => 'Server Host URL';

  @override
  String get loginView_emailField => 'Eamil';

  @override
  String get loginView_passwordField => 'Password';

  @override
  String get loginView_validation_hostEmpty => 'Podaj adres hosta';

  @override
  String get loginView_validation_hostInvalid => 'Nieprawidłowy adres url';
}
