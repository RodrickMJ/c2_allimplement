// features/home/presentation/pages/create_client_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/clients_provider.dart';

class CreateClientScreen extends StatefulWidget {
  const CreateClientScreen({super.key});
  @override
  State<CreateClientScreen> createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _termCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addrCtrl.dispose();
    _amountCtrl.dispose();
    _termCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos read() aquí para NO escuchar cambios en todo el widget
    final provider = context.read<ClientsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Cliente + Préstamo"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameCtrl, "Nombre completo", Icons.person),
              const SizedBox(height: 16),
              _buildTextField(_emailCtrl, "Email", Icons.email, keyboard: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(_phoneCtrl, "Teléfono", Icons.phone, keyboard: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(_addrCtrl, "Dirección", Icons.location_on),
              const SizedBox(height: 24),

              const Text("Préstamo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField(_amountCtrl, "Monto (USD)", Icons.attach_money, keyboard: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(_termCtrl, "Plazo (20, 25, 30 días)", Icons.calendar_today, keyboard: TextInputType.number),
              const SizedBox(height: 24),

              // Aquí usamos Consumer SOLO para la parte que depende del estado del provider
              Consumer<ClientsProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      if (provider.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            provider.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: provider.loading ? null : () => _createClient(provider),
                        child: provider.loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Crear Cliente y Préstamo"),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (v) => v?.trim().isEmpty == true ? "Requerido" : null,
    );
  }

  void _createClient(ClientsProvider provider) async {
    if (_formKey.currentState!.validate()) {
      final success = await provider.addClientAndLoan(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _phoneCtrl.text.trim(),
        _addrCtrl.text.trim(),
        int.tryParse(_amountCtrl.text) ?? 0,
        int.tryParse(_termCtrl.text) ?? 0,
      );

      if (success && mounted) {
        context.pop(); // Vuelve a la lista de clientes
      }
    }
  }
}