import 'package:flutter/material.dart';
import 'feature/auth/presentation/pages/login_screen.dart';
import 'feature/auth/presentation/pages/register_screen.dart';
import 'feature/home/presentation/pages/clients_screen.dart';

import 'package:device_preview/device_preview.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,

      title: "Loans App",
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/login",
      routes: {
        "/login": (_) => const LoginScreen(),
        "/register": (_) => const RegisterScreen(),
        "/home": (_) => const ClientsScreen(),
      },
    );
  }
}
