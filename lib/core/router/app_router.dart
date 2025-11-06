// core/router/app_router.dart
import 'package:a2c2/core/router/app_routes.dart';
import 'package:a2c2/feature/home/presentation/providers/clients_provider.dart';
import 'package:go_router/go_router.dart';

import '../../feature/auth/presentation/pages/splash_screen.dart';
import '../../feature/auth/presentation/pages/login_screen.dart';
import '../../feature/auth/presentation/pages/register_screen.dart';
import '../../feature/home/presentation/pages/clients_screen.dart';
import '../../feature/home/presentation/pages/create_client_screen.dart';
import '../../feature/auth/presentation/providers/auth_provider.dart';
import '../di/injection.dart';

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
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) {
          final provider = getIt<ClientsProvider>();
          provider.fetchClients();
          return const ClientsScreen();
        },
        routes: [
          GoRoute(
            path: AppRoutes.createClientPath,
            name: AppRoutes.createClient,
            builder: (context, state) => const CreateClientScreen(),
          ),
        ],
      ),
    ],
    // uso de contexto para el pero no reconce el token
    redirect: (context, state) {
      final isLoggedIn = authProvider.user != null;
      final location = state.matchedLocation;

      if (location == AppRoutes.splashPath) return null;

      if (!isLoggedIn &&
          ![AppRoutes.loginPath, AppRoutes.registerPath].contains(location)) {
        return AppRoutes.loginPath;
      }

      if (isLoggedIn &&
          [AppRoutes.loginPath, AppRoutes.registerPath].contains(location)) {
        return AppRoutes.homePath;
      }

      return null;
    },
  );
}
