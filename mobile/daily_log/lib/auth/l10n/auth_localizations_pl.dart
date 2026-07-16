// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AuthLocalizationsPl extends AuthLocalizations {
  AuthLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get authInvalidCredentials => 'Nieprawidłowy adres e-mail lub hasło';

  @override
  String get authUnauthorized => 'Nie masz uprawnień do wykonania tej operacji';

  @override
  String get networkError => 'Nie udało się połączyć z serwerem';

  @override
  String get requestTimeout => 'Serwer nie odpowiedział w wymaganym czasie';

  @override
  String get badCertificate => 'Nie udało się zweryfikować certyfikatu serwera';

  @override
  String get requestCancelled => 'Żądanie zostało anulowane';

  @override
  String get badRequest => 'Żądanie jest nieprawidłowe';

  @override
  String get notFound => 'Nie znaleziono żądanego zasobu';

  @override
  String get invalidServerResponse => 'Serwer zwrócił nieprawidłową odpowiedź';

  @override
  String serverError(int statusCode) {
    return 'Błąd serwera ($statusCode)';
  }

  @override
  String get validationError => 'Przesłane dane są nieprawidłowe';

  @override
  String get emailInvalid => 'Podaj poprawny adres e-mail';

  @override
  String get emailRequired => 'Podaj adres e-mail';

  @override
  String get passwordRequired => 'Podaj hasło';

  @override
  String get passwordTooShort => 'Hasło jest zbyt krótkie';

  @override
  String get unknownError => 'Wystąpił nieoczekiwany błąd';

  @override
  String get loginView_Title => 'Logowanie';

  @override
  String get loginView_formSubmit => 'Login';

  @override
  String get loginView_serverHostField => 'Adres URL servera';

  @override
  String get loginView_emailField => 'Adres Email';

  @override
  String get loginView_passwordField => 'Hasło';

  @override
  String get loginView_validation_hostEmpty => 'Podaj adres hosta';

  @override
  String get loginView_validation_hostInvalid => 'Nieprawidłowy adres url';
}
