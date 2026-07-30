import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PrivacyShield extends StatelessWidget {
  final Widget child;
  final bool isShieldActive;

  const PrivacyShield({
    super.key,
    required this.child,
    required this.isShieldActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isShieldActive) ...<Widget>[
          // Efecto de desenfoque sobre el contenido subyacente
          ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white,
                      size: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Bóveda Protegida',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'La información está oculta por seguridad',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
