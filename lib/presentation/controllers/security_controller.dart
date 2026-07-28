import 'package:flutter/foundation.dart';
import '../../domain/repositories/security_repository.dart';

class SecurityController extends ChangeNotifier {
  SecurityController({required this._repository});

  final SecurityRepository _repository;

  String? _currentToken;
  bool _isLoading = false;
  String? _errorMessage;

  String? get currentToken => _currentToken;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> generateAndSaveToken() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String newToken =
          'vault_token_${DateTime.now().millisecondsSinceEpoch}';
      await _repository.saveToken(newToken);
      _currentToken = newToken;
    } catch (e) {
      _errorMessage = 'Error de seguridad al guardar el token.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadToken() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String? token = await _repository.getToken();
      _currentToken = token;
    } catch (e) {
      _errorMessage = 'Error de seguridad al leer el token.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteToken();
      _currentToken = null;
    } catch (e) {
      _errorMessage = 'Error de seguridad al eliminar el token.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
