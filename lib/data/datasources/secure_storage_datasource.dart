import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDatasource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'AUTH_TOKEN_KEY';

  Future<void> writeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
