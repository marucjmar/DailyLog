import 'package:daily_log/stores/session.dart';
import 'package:flutter/material.dart';

class SessionRepository extends ChangeNotifier {
  bool get isLoggedIn => SessionStorage.isLoggedIn;

  SessionRepository._();
  static final instance = SessionRepository._();

  Future<void> init() async {
    await SessionStorage.init();
  }

  Future<void> logout() async {
    SessionStorage.clearSession();
    notifyListeners();
  }

  Future<void> login({
    required int userId,
    required int id,
    required String idToken,
    required String refreshToken,
    required String deviceToken,
    required int userType,
    required String accessToken,
    required String hostUrl,
  }) async {
    SessionStorage.saveSession(userId: userId, id: id, idToken: idToken, refreshToken: refreshToken, deviceToken: deviceToken, userType: userType, accessToken: accessToken, hostUrl: hostUrl);
    notifyListeners();
  }
}