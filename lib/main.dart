import 'package:datavault_pro/application/vault_service.dart';
import 'package:datavault_pro/data/datasources/secure_storage_datasource.dart';
import 'package:datavault_pro/data/repositories/local_security_repository.dart';
import 'package:datavault_pro/data/repositories/vault_repository_impl.dart';
import 'package:datavault_pro/presentation/controllers/security_controller.dart';
import 'package:datavault_pro/presentation/controllers/vault_controller.dart';
import 'package:datavault_pro/presentation/screens/home_screen.dart';
import 'package:datavault_pro/presentation/screens/security_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final SecureStorageDatasource datasource = SecureStorageDatasource();
  final LocalSecurityRepository securityRepository = LocalSecurityRepository(
    datasource: datasource,
  );
  final SecurityController securityController = SecurityController(
    repository: securityRepository,
  );

  final VaultRepositoryImpl vaultRepository = VaultRepositoryImpl();
  final VaultService vaultService = VaultService();
  final VaultController vaultController = VaultController(
    repository: vaultRepository,
    vaultService: vaultService,
  );

  runApp(
    DataVaultApp(
      securityController: securityController,
      vaultController: vaultController,
    ),
  );
}

class DataVaultApp extends StatefulWidget {
  final SecurityController securityController;
  final VaultController vaultController;

  const DataVaultApp({
    super.key,
    required this.securityController,
    required this.vaultController,
  });

  @override
  State<DataVaultApp> createState() => _DataVaultAppState();
}

class _DataVaultAppState extends State<DataVaultApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      SecurityScreen(controller: widget.securityController),
      HomeScreen(
        securityController: widget.securityController,
        vaultController: widget.vaultController,
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DataVault Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.security),
              label: 'Seguridad',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'Bóveda'),
          ],
        ),
      ),
    );
  }
}
