import 'package:flutter/material.dart';
import '../controllers/security_controller.dart';

class SecurityScreen extends StatefulWidget {
  final SecurityController controller;

  const SecurityScreen({super.key, required this.controller});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
    // Verificación automática al iniciar (Extensión opcional del Paso 2)
    widget.controller.loadToken();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;

    final String? error = widget.controller.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget? child) {
        final String? token = widget.controller.currentToken;
        final bool isLoading = widget.controller.isLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('DataVault Pro - Token'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Estado del Token:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isLoading)
                          const CircularProgressIndicator()
                        else
                          SelectableText(
                            token ?? 'No hay token almacenado',
                            style: TextStyle(
                              fontSize: 14,
                              color: token != null ? Colors.green : Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => widget.controller.generateAndSaveToken(),
                  icon: const Icon(Icons.security),
                  label: const Text('Generar y Guardar Token'),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => widget.controller.loadToken(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Leer Token del Almacenamiento'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => widget.controller.logout(),
                  icon: const Icon(Icons.delete_forever),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  label: const Text('Eliminar Token (Logout)'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
