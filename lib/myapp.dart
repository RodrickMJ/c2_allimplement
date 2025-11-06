// myapp.dart
import 'package:a2c2/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'core/router/app_router.dart';
import 'core/di/injection.dart';
import 'feature/auth/presentation/providers/auth_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = getIt<AuthProvider>();
    final router = AppRouter(authProvider).router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'app practica allClasses',

      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: AppTheme.light(null),
      darkTheme: AppTheme.dark(null),
      themeMode: ThemeMode.system,

      routerConfig: router,
    );
  }
}
