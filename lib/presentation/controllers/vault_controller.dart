import 'package:flutter/foundation.dart';
import '../../application/vault_service.dart';
import '../../domain/entities/vault_item.dart';
import '../../domain/repositories/vault_repository.dart';

class VaultController extends ChangeNotifier {
  VaultController({required this._repository, required this._vaultService});

  final VaultRepository _repository;
  final VaultService _vaultService;

  List<VaultItem> _items = <VaultItem>[];
  bool _isProcessing = false;
  int _executionTimeMs = 0;

  List<VaultItem> get items => _items;
  bool get isProcessing => _isProcessing;
  int get executionTimeMs => _executionTimeMs;

  /// Procesa datos SIN Isolate (Forma tradicional/primitiva que congela la UI)
  Future<void> decryptVaultWithoutIsolate(String token) async {
    _isProcessing = true;
    notifyListeners();

    // Pequeña pausa para permitir que Flutter dibuje el spinner en pantalla
    // antes de que el ciclo for bloquee el hilo principal.
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final Stopwatch stopwatch = Stopwatch()..start();
    final List<VaultItem> rawItems = await _repository.fetchEncryptedData();

    // Ejecución SÍNCRONA en el Hilo Principal
    _items = _vaultService.processVaultDataSync(
      rawItems: rawItems,
      tokenKey: token,
    );

    stopwatch.stop();
    _executionTimeMs = stopwatch.elapsedMilliseconds;
    _isProcessing = false;
    notifyListeners();
  }

  /// Procesa datos mediante ISOLATE (Fluidez total, 60fps)
  Future<void> decryptVaultWithIsolate(String token) async {
    _isProcessing = true;
    notifyListeners();

    final Stopwatch stopwatch = Stopwatch()..start();
    final List<VaultItem> rawItems = await _repository.fetchEncryptedData();

    _items = await _vaultService.processVaultDataInIsolate(
      rawItems: rawItems,
      tokenKey: token,
    );

    stopwatch.stop();
    _executionTimeMs = stopwatch.elapsedMilliseconds;
    _isProcessing = false;
    notifyListeners();
  }
}
