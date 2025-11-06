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

  await configureDependencies();

  final sessionConfig = SessionConfig(
    invalidateSessionForAppLostFocus: const Duration(seconds: 20),
    invalidateSessionForUserInactivity: const Duration(seconds: 20),
  );

  // Escucha timeout → logout automático
  // sessionConfig.stream.listen((event) {
  //   if (event == SessionTimeoutState.userInactivityTimeout ||
  //       event == SessionTimeoutState.appLostFocusTimeout ) {
  //     getIt<AuthProvider>().logout();
  //   }
  // });

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (contex) => MultiProvider(
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