import 'package:get_storage/get_storage.dart';

class SessionStorage {
  static final _storageId = 'session';
  static final _storage = GetStorage(_storageId);

  // Keys
  static const String _userIdKey = 'user_id';
  static const String _idKey = 'id';
  static const String _accessToken = 'access_token';
  static const String _hostUrl = 'host_url';

  static Future<void> init() async {
    await GetStorage.init(_storageId);
  }
  // Save session data
  static void saveSession({
    required String userId,
    required String id,
    required String accessToken,
    required String hostUrl,
  }) {
    _storage.write(_userIdKey, userId);
    _storage.write(_idKey, id);
    _storage.write(_accessToken, accessToken);
    _storage.write(_hostUrl, hostUrl);
  }

  // Getters
  static int? get userId => _storage.read(_userIdKey);
  static int? get id => _storage.read(_idKey);
  static String? get accessToken => _storage.read(_accessToken);
  static String? get hostUrl => _storage.read(_hostUrl);

  static String get token => accessToken ?? '';
  static bool get isLoggedIn => accessToken != null;

  // Clear all session data
  static void clearSession() {
    _storage.remove(_userIdKey);
    _storage.remove(_idKey);
    _storage.remove(_accessToken);
    _storage.remove(_hostUrl);
  }
}