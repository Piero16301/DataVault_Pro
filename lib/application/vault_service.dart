import 'dart:isolate';
import '../domain/entities/vault_item.dart';

/// Parámetros enviados al Isolate (Cumple con Reto 2: argumentos dinámicos)
class VaultProcessingPayload {
  final List<VaultItem> items;
  final String tokenKey;

  const VaultProcessingPayload({required this.items, required this.tokenKey});
}

class VaultService {
  /// Procesa los datos en el HILO PRINCIPAL (Sin Isolate).
  /// Esto bloqueará el Event Loop de Dart y congelará la UI.
  List<VaultItem> processVaultDataSync({
    required List<VaultItem> rawItems,
    required String tokenKey,
  }) {
    final VaultProcessingPayload payload = VaultProcessingPayload(
      items: rawItems,
      tokenKey: tokenKey,
    );

    // Llama directamente a la función pesada en el mismo hilo
    return _heavyCryptoProcessing(payload);
  }

  /// Ejecuta el procesamiento pesado fuera del hilo principal usando Isolate.run
  Future<List<VaultItem>> processVaultDataInIsolate({
    required List<VaultItem> rawItems,
    required String tokenKey,
  }) async {
    final VaultProcessingPayload payload = VaultProcessingPayload(
      items: rawItems,
      tokenKey: tokenKey,
    );

    // Se delega la tarea intensiva al Isolate secundario
    return await Isolate.run<List<VaultItem>>(
      () => _heavyCryptoProcessing(payload),
    );
  }

  /// Función estática / nivel superior aislada para el Isolate
  static List<VaultItem> _heavyCryptoProcessing(
    VaultProcessingPayload payload,
  ) {
    final List<VaultItem> processed = <VaultItem>[];

    for (final VaultItem item in payload.items) {
      // Simulación de iteraciones intensivas de CPU (Cálculo criptográfico ficticio)
      String tempHash = item.decryptedPayload;
      for (int i = 0; i < 500; i++) {
        tempHash = '${tempHash}_${payload.tokenKey.hashCode + i}';
      }

      processed.add(
        VaultItem(
          id: item.id,
          title: item.title,
          decryptedPayload:
              'DESCRYPTED [Key: ${payload.tokenKey.substring(0, 8)}...]: Item ${item.id}',
        ),
      );
    }

    return processed;
  }
}
