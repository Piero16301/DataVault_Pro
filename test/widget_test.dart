import 'package:datavault_pro/application/vault_service.dart';
import 'package:datavault_pro/data/repositories/vault_repository_impl.dart';
import 'package:datavault_pro/domain/repositories/security_repository.dart';
import 'package:datavault_pro/presentation/controllers/security_controller.dart';
import 'package:datavault_pro/presentation/controllers/vault_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:datavault_pro/main.dart';

class MockSecurityRepository extends SecurityRepository {
  @override
  Future<void> deleteToken() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getToken() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveToken(String token) {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      DataVaultApp(
        securityController: SecurityController(
          repository: MockSecurityRepository(),
        ),
        vaultController: VaultController(
          repository: VaultRepositoryImpl(),
          vaultService: VaultService(),
        ),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
