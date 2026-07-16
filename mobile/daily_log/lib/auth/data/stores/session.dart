import 'package:daily_log/auth/domain/models/session.dart';
import 'package:get_storage/get_storage.dart';

class SessionStorage {
  static const _storageId = 'session';

  static const String _userIdKey = 'user_id';
  static const String _idKey = 'id';
  static const String _accessTokenKey = 'access_token';
  static const String _hostUrlKey = 'host_url';

  final GetStorage _storage;

  SessionStorage._(this._storage);

  static Future<SessionStorage> create() async {
    await GetStorage.init(_storageId);

    return SessionStorage._(
      GetStorage(_storageId),
    );
  }
  
  SessionStorage({
    GetStorage? storage,
  }) : _storage = storage ?? GetStorage(_storageId);

  static Future<void> initialize() {
    return GetStorage.init(_storageId);
  }

  String? get userId => _storage.read<String>(_userIdKey);
  String? get id => _storage.read<String>(_idKey);
  String? get accessToken => _storage.read<String>(_accessTokenKey);
  String? get hostUrl => _storage.read<String>(_hostUrlKey);

  bool get isLoggedIn {
    final token = accessToken;
    return token != null && token.isNotEmpty;
  }

  Session? readSession() {
    final storedUserId = userId;
    final storedId = id;
    final storedAccessToken = accessToken;
    final storedHostUrl = hostUrl;

    if (storedUserId == null ||
        storedId == null ||
        storedAccessToken == null ||
        storedAccessToken.isEmpty ||
        storedHostUrl == null ||
        storedHostUrl.isEmpty) {
      return null;
    }

    return Session(
      userId: storedUserId,
      id: storedId,
      accessToken: storedAccessToken,
      hostUrl: storedHostUrl,
    );
  }

  Future<void> saveSession(Session session) async {
    await Future.wait([
      _storage.write(_userIdKey, session.userId),
      _storage.write(_idKey, session.id),
      _storage.write(_accessTokenKey, session.accessToken),
      _storage.write(_hostUrlKey, session.hostUrl),
    ]);
  }

  Future<void> clearSession() async {
    await Future.wait([
      _storage.remove(_userIdKey),
      _storage.remove(_idKey),
      _storage.remove(_accessTokenKey),
      _storage.remove(_hostUrlKey),
    ]);
  }
}