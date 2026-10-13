import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  TokenStorage(this._prefs);

  static const String _tokenKey = 'auth_token';
  static const String _expiresAtKey = 'auth_token_expires_at';

  final SharedPreferences _prefs;

  String? get token => _prefs.getString(_tokenKey);

  bool get hasToken => _prefs.getString(_tokenKey) != null;

  Future<void> save(String token, int expiresAt) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setInt(_expiresAtKey, expiresAt);
  }

  bool get isExpired {
    final expiresAt = _prefs.getInt(_expiresAtKey);
    if (expiresAt == null) {
      return true;
    }
    final expiry = DateTime.fromMillisecondsSinceEpoch(expiresAt);
    return DateTime.now().isAfter(expiry);
  }

  Future<void> clear() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_expiresAtKey);
  }
}
