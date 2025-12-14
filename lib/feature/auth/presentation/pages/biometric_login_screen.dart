// features/auth/presentation/pages/biometric_login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/local_auth_service.dart';

class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _tryBiometricLogin();
  }

  Future<void> _tryBiometricLogin() async {
    if (_isAuthenticating) return;

    setState(() => _isAuthenticating = true);

    final bool success = await LocalAuthService.authenticate();

    if (!mounted) return;

    setState(() => _isAuthenticating = false);

    if (success) {
      // ¡Login biométrico exitoso! → Va directo a home
      context.goNamed(AppRoutes.home);
    } else {
      // Falla o cancela → login tradicional
      context.goNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint,
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 40),
            Text(
              "Bienvenido de nuevo",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isAuthenticating ? "Autenticando..." : "Usa tu huella o rostro",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            if (!_isAuthenticating)
              TextButton(
                onPressed: () => context.goNamed(AppRoutes.login),
                child: const Text("Iniciar sesión con email"),
              ),
          ],
        ),
      ),
    );
  }
}