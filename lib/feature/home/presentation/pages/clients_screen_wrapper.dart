// features/home/presentation/pages/clients_screen_wrapper.dart
import 'package:a2c2/feature/home/presentation/pages/clients_screen.dart';
import 'package:a2c2/feature/home/presentation/providers/clients_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientsScreenWrapper extends StatefulWidget {
  const ClientsScreenWrapper({super.key});

  @override
  State<ClientsScreenWrapper> createState() => _ClientsScreenWrapperState();
}

class _ClientsScreenWrapperState extends State<ClientsScreenWrapper> {
  @override
  void initState() {
    super.initState();
    // Carga segura después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientsProvider>().fetchClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ClientsScreen();
  }
}