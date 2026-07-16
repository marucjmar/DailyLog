import 'package:daily_log/auth/data/api/errors.dart';
import 'package:daily_log/auth/domain/models/session.dart';
import 'package:daily_log/auth/domain/repositories/auth.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController({
    required this._repository,
  });

  Session? _session;
  Session? get session => _session;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ApiException? _error;
  ApiException? get error => _error;

  bool get isAuthenticated => _session != null;

  Future<bool> login({
    required Uri serverUri,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _session = await _repository.login(
        serverUri: serverUri,
        email: email,
        password: password,
      );

      return true;
    } on ApiException catch (error) {
      _error = error;
      return false;
    } catch (error, stackTrace) {
      debugPrint('Nieoczekiwany błąd logowania: $error');
      debugPrintStack(stackTrace: stackTrace);

      _error = const ApiException.unknown();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _session = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    if (_error == null) {
      return;
    }

    _error = null;
    notifyListeners();
  }
}
