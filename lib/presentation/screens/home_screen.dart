import 'package:datavault_pro/domain/entities/vault_item.dart';
import 'package:flutter/material.dart';
import '../controllers/security_controller.dart';
import '../controllers/vault_controller.dart';

class HomeScreen extends StatelessWidget {
  final SecurityController securityController;
  final VaultController vaultController;

  const HomeScreen({
    super.key,
    required this.securityController,
    required this.vaultController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        securityController,
        vaultController,
      ]),
      builder: (BuildContext context, Widget? child) {
        final String? token = securityController.currentToken;
        final bool isProcessing = vaultController.isProcessing;
        final int itemCount = vaultController.items.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('DataVault Pro - Isolates'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  color: Colors.indigo.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Token de sesión active:',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          token ??
                              'No hay token. Inicia sesión en la otra pantalla.',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: (token == null || isProcessing)
                      ? null
                      : () => vaultController.decryptVaultWithIsolate(token),
                  icon: const Icon(Icons.bolt),
                  label: const Text('Descifrar con ISOLATE (Fluido)'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: (token == null || isProcessing)
                      ? null
                      : () => vaultController.decryptVaultWithoutIsolate(token),
                  icon: const Icon(Icons.block),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  label: const Text('Descifrar SIN Isolate (Bloquea UI)'),
                ),
                const SizedBox(height: 16),
                if (isProcessing) ...<Widget>[
                  const Center(
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Procesando en hilo secundario...'),
                      ],
                    ),
                  ),
                ] else if (itemCount > 0) ...<Widget>[
                  Text(
                    '¡Procesados $itemCount registros en ${vaultController.executionTimeMs} ms!',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 50,
                      itemBuilder: (BuildContext context, int index) {
                        final VaultItem item = vaultController.items[index];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.lock_open, size: 20),
                          title: Text(item.title),
                          subtitle: Text(item.decryptedPayload),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
