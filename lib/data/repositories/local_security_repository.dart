import '../../domain/repositories/security_repository.dart';
import '../datasources/secure_storage_datasource.dart';

class LocalSecurityRepository implements SecurityRepository {
  LocalSecurityRepository({required this._datasource});

  final SecureStorageDatasource _datasource;

  @override
  Future<void> saveToken(String token) async {
    await _datasource.writeToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await _datasource.readToken();
  }

  @override
  Future<void> deleteToken() async {
    await _datasource.deleteToken();
  }
}
