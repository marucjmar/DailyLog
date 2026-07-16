import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'auth_localizations_en.dart';
import 'auth_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AuthLocalizations
/// returned by `AuthLocalizations.of(context)`.
///
/// Applications need to include `AuthLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/auth_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AuthLocalizations.localizationsDelegates,
///   supportedLocales: AuthLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AuthLocalizations.supportedLocales
/// property.
abstract class AuthLocalizations {
  AuthLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AuthLocalizations? of(BuildContext context) {
    return Localizations.of<AuthLocalizations>(context, AuthLocalizations);
  }

  static const LocalizationsDelegate<AuthLocalizations> delegate = _AuthLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get authInvalidCredentials;

  /// No description provided for @authUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action'**
  String get authUnauthorized;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server'**
  String get networkError;

  /// No description provided for @requestTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server did not respond in time'**
  String get requestTimeout;

  /// No description provided for @badCertificate.
  ///
  /// In en, this message translates to:
  /// **'The server certificate could not be verified'**
  String get badCertificate;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled'**
  String get requestCancelled;

  /// No description provided for @badRequest.
  ///
  /// In en, this message translates to:
  /// **'The request is invalid'**
  String get badRequest;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found'**
  String get notFound;

  /// No description provided for @invalidServerResponse.
  ///
  /// In en, this message translates to:
  /// **'The server returned an invalid response'**
  String get invalidServerResponse;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error ({statusCode})'**
  String serverError(int statusCode);

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'The submitted data is invalid'**
  String get validationError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unknownError;

  /// No description provided for @loginView_Title.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginView_Title;

  /// No description provided for @loginView_formSubmit.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginView_formSubmit;

  /// No description provided for @loginView_serverHostField.
  ///
  /// In en, this message translates to:
  /// **'Server Host URL'**
  String get loginView_serverHostField;

  /// No description provided for @loginView_emailField.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginView_emailField;

  /// No description provided for @loginView_passwordField.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginView_passwordField;

  /// No description provided for @loginView_validation_hostEmpty.
  ///
  /// In en, this message translates to:
  /// **'Podaj adres hosta'**
  String get loginView_validation_hostEmpty;

  /// No description provided for @loginView_validation_hostInvalid.
  ///
  /// In en, this message translates to:
  /// **'Nieprawidłowy adres url'**
  String get loginView_validation_hostInvalid;
}

class _AuthLocalizationsDelegate extends LocalizationsDelegate<AuthLocalizations> {
  const _AuthLocalizationsDelegate();

  @override
  Future<AuthLocalizations> load(Locale locale) {
    return SynchronousFuture<AuthLocalizations>(lookupAuthLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AuthLocalizationsDelegate old) => false;
}

AuthLocalizations lookupAuthLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AuthLocalizationsEn();
    case 'pl': return AuthLocalizationsPl();
  }

  throw FlutterError(
    'AuthLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
