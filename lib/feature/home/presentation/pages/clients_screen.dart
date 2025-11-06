// features/home/presentation/pages/clients_screen.dart
import 'package:a2c2/feature/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/clients_provider.dart';
import '../widgets/client_card.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: provider.fetchClients,
            child: _buildBody(provider, constraints),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.createClient),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildBody(ClientsProvider provider, BoxConstraints constraints) {
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }
    if (provider.clients.isEmpty) {
      return const Center(child: Text("No hay clientes"));
    }

    final isWide = constraints.maxWidth > 600;
    return isWide
        ? GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.clients.length,
            itemBuilder: (context, i) =>
                ClientCard(client: provider.clients[i]),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.clients.length,
            itemBuilder: (context, i) =>
                ClientCard(client: provider.clients[i]),
          );
  }
}
