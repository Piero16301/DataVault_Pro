import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:datavault_pro/domain/entities/vault_item.dart';
import 'package:datavault_pro/domain/repositories/security_repository.dart';
import 'package:datavault_pro/presentation/controllers/security_controller.dart';
import 'package:datavault_pro/presentation/screens/widgets/privacy_shield.dart';

/// Implementación simulada (Fake) del repositorio para pruebas unitarias sin dependencias nativas
class FakeSecurityRepository implements SecurityRepository {
  String? _storedToken;

  @override
  Future<void> saveToken(String token) async {
    _storedToken = token;
  }

  @override
  Future<String?> getToken() async {
    return _storedToken;
  }

  @override
  Future<void> deleteToken() async {
    _storedToken = null;
  }
}

class ErrorSecurityRepository implements SecurityRepository {
  @override
  Future<void> saveToken(String token) async {
    throw Exception('Error simulado');
  }

  @override
  Future<String?> getToken() async {
    throw Exception('Error simulado');
  }

  @override
  Future<void> deleteToken() async {
    throw Exception('Error simulado');
  }
}

void main() {
  group('1. Pruebas de Dominio - VaultItem', () {
    test('Debe crear una instancia válida de VaultItem', () {
      const VaultItem item = VaultItem(
        id: '1',
        title: 'Registro de Prueba',
        decryptedPayload: 'DATOS_DESCIFRADOS_OK',
      );

      expect(item.id, equals('1'));
      expect(item.title, equals('Registro de Prueba'));
      expect(item.decryptedPayload, equals('DATOS_DESCIFRADOS_OK'));
    });
  });

  group('2. Pruebas de Estado - SecurityController', () {
    test('Debe generar, guardar y actualizar el token correctamente', () async {
      final FakeSecurityRepository repository = FakeSecurityRepository();
      final SecurityController controller = SecurityController(
        repository: repository,
      );

      expect(controller.currentToken, isNull);
      expect(controller.isLoading, isFalse);

      await controller.generateAndSaveToken();

      expect(controller.currentToken, isNotNull);
      expect(controller.currentToken, startsWith('vault_token_'));
      expect(controller.isLoading, isFalse);
    });

    test('Debe eliminar el token al ejecutar logout', () async {
      final FakeSecurityRepository repository = FakeSecurityRepository();
      final SecurityController controller = SecurityController(
        repository: repository,
      );

      await controller.generateAndSaveToken();
      expect(controller.currentToken, isNotNull);

      await controller.logout();
      expect(controller.currentToken, isNull);
    });

    test('Debe cargar el token correctamente', () async {
      final FakeSecurityRepository repository = FakeSecurityRepository();
      final SecurityController controller = SecurityController(
        repository: repository,
      );

      await repository.saveToken('token_cargado_123');
      await controller.loadToken();

      expect(controller.currentToken, equals('token_cargado_123'));
      expect(controller.errorMessage, isNull);
    });

    test('Debe manejar error al generar y guardar el token', () async {
      final ErrorSecurityRepository repository = ErrorSecurityRepository();
      final SecurityController controller = SecurityController(
        repository: repository,
      );

      await controller.generateAndSaveToken();

      expect(controller.currentToken, isNull);
      expect(controller.errorMessage, equals('Error de seguridad al guardar el token.'));
    });

    test('Debe manejar error al cargar el token', () async {
      final ErrorSecurityRepository repository = ErrorSecurityRepository();
      final SecurityController controller = SecurityController(
        repository: repository,
      );

      await controller.loadToken();

      expect(controller.currentToken, isNull);
      expect(controller.errorMessage, equals('Error de seguridad al leer el token.'));
    });

    test('Debe manejar error al hacer logout', () async {
      final ErrorSecurityRepository repository = ErrorSecurityRepository();
      final SecurityController controller = SecurityController(
        repository: repository,
      );

      await controller.logout();

      expect(controller.errorMessage, equals('Error de seguridad al eliminar el token.'));
    });
  });

  group('3. Pruebas de Interfaz (Widget Test) - PrivacyShield', () {
    testWidgets(
      'Debe mostrar el contenido normal cuando el escudo está inactivo',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: PrivacyShield(
              isShieldActive: false,
              child: Text('Contenido Visible de la Bóveda'),
            ),
          ),
        );

        expect(find.text('Contenido Visible de la Bóveda'), findsOneWidget);
        expect(find.text('Bóveda Protegida'), findsNothing);
      },
    );

    testWidgets('Debe renderizar el escudo de privacidad cuando está activo', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PrivacyShield(
            isShieldActive: true,
            child: Text('Contenido Sensible'),
          ),
        ),
      );

      expect(find.text('Bóveda Protegida'), findsOneWidget);
      expect(
        find.text('La información está oculta por seguridad'),
        findsOneWidget,
      );
    });
  });
}
