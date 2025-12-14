// features/auth/presentation/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/local_auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ejecutamos el código asíncrono de forma segura
      Future(() async {
        final auth = context.read<AuthProvider>();

        if (auth.user != null) {
          final bool biometricEnabled = await LocalAuthService.isBiometricEnabled();
          final bool canUseBiometric = await LocalAuthService.canAuthenticate();

          if (biometricEnabled && canUseBiometric) {
            context.goNamed(AppRoutes.biometricLogin);
          } else {
            context.goNamed(AppRoutes.home);
          }
        } else {
          context.goNamed(AppRoutes.login);
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              "Loans App",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}