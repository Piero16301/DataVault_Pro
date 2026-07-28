import '../../domain/entities/vault_item.dart';
import '../../domain/repositories/vault_repository.dart';

class VaultRepositoryImpl implements VaultRepository {
  @override
  Future<List<VaultItem>> fetchEncryptedData() async {
    // Simula una breve latencia de red/disco
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Genera 10,000 elementos crudos encriptados
    return List<VaultItem>.generate(
      10000,
      (int index) => VaultItem(
        id: 'item_$index',
        title: 'Registro de Bóveda #$index',
        decryptedPayload: 'RAW_ENCRYPTED_DATA_HASH_$index',
      ),
    );
  }
}
