import '../entities/vault_item.dart';

abstract class VaultRepository {
  Future<List<VaultItem>> fetchEncryptedData();
}
