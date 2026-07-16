import 'package:daily_log/auth/data/api/auth.dart';
import 'package:daily_log/auth/domain/models/session.dart';
import 'package:daily_log/auth/data/stores/session.dart';
import 'package:daily_log/auth/data/mappers/session_response.dart';

abstract interface class AuthRepository {
  Future<Session> login({
    required Uri serverUri,
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final SessionStorage _sessionStorage;

  AuthRepositoryImpl({
    required AuthApi authApi,
    required SessionStorage sessionStorage,
  }) : _authApi = authApi,
       _sessionStorage = sessionStorage;

  bool get isLoggedIn => _sessionStorage.isLoggedIn;

  Future<void> logout() {
    return _sessionStorage.clearSession();
  }

  Future<Session> login({
    required Uri serverUri,
    required String email,
    required String password,
  }) async {
    final response = await _authApi.login(
      serverUri: serverUri,
      email: email,
      password: password,
    );

    final session = response.toDomain(hostUrl: serverUri.toString());

    await _sessionStorage.saveSession(session);

    return session;
  }
}
