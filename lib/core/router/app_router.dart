// core/router/app_router.dart
import 'package:a2c2/core/router/app_routes.dart';
import 'package:a2c2/feature/home/presentation/pages/clients_screen_wrapper.dart';
import 'package:go_router/go_router.dart';

import '../../feature/auth/presentation/pages/splash_screen.dart';
import '../../feature/auth/presentation/pages/login_screen.dart';
import '../../feature/auth/presentation/pages/register_screen.dart';
import '../../feature/auth/presentation/pages/biometric_login_screen.dart';  // ← NUEVO IMPORT

import '../../feature/home/presentation/pages/create_client_screen.dart';
import '../../feature/auth/presentation/providers/auth_provider.dart';

class AppRouter {
  final AuthProvider authProvider;
  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: authProvider,
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      // ← NUEVA RUTA PARA BIOMETRÍA
      GoRoute(
        path: AppRoutes.biometricLoginPath,
        name: AppRoutes.biometricLogin,
        builder: (context, state) => const BiometricLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => const ClientsScreenWrapper(),
        routes: [
          GoRoute(
            path: AppRoutes.createClientPath,
            name: AppRoutes.createClient,
            builder: (context, state) => const CreateClientScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authProvider.user != null;
      final location = state.matchedLocation;

      // Permitimos el splash siempre
      if (location == AppRoutes.splashPath) return null;

      // Si no está logueado y trata de ir a cualquier lado que no sea login/register → redirige a login
      if (!isLoggedIn &&
          ![AppRoutes.loginPath, AppRoutes.registerPath, AppRoutes.biometricLoginPath].contains(location)) {
        return AppRoutes.loginPath;
      }

      // Si está logueado y trata de ir a login/register → redirige a home
      if (isLoggedIn &&
          [AppRoutes.loginPath, AppRoutes.registerPath].contains(location)) {
        return AppRoutes.homePath;
      }

      return null;
    },
  );
}