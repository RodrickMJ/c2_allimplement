// main.dart
import 'package:a2c2/feature/auth/presentation/providers/auth_provider.dart';
import 'package:a2c2/feature/home/presentation/providers/clients_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa dependencias (incluyendo AuthProvider y ClientsProvider)
  await configureDependencies();

  final sessionConfig = SessionConfig(
    invalidateSessionForAppLostFocus: const Duration(seconds: 20),
    invalidateSessionForUserInactivity: const Duration(seconds: 20),
  );

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
        providers: [
          Provider<SessionConfig>.value(value: sessionConfig),
          ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
          ChangeNotifierProvider(create: (_) => getIt<ClientsProvider>()),
        ],
        child: SessionTimeoutManager(
          sessionConfig: sessionConfig,
          child: const MyApp(),
        ),
      ),
    ),
  );
}