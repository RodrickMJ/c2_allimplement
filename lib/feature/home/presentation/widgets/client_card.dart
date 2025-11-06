// features/home/presentation/widgets/client_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/client.dart';
import '../providers/clients_provider.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  const ClientCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            client.name.isNotEmpty ? client.name[0].toUpperCase() : "?",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(client.email),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(context),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar cliente"),
        content: Text("¿Eliminar a ${client.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      context.read<ClientsProvider>().removeClient(client.id);
    }
  }
}