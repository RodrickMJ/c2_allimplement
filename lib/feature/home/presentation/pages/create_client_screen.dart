import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clients_provider.dart';

class CreateClientScreen extends StatefulWidget {
  const CreateClientScreen({super.key});

  @override
  State<CreateClientScreen> createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _direccionController = TextEditingController();
  final _amountController = TextEditingController();
  final _termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Cliente + Préstamo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nombre")),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "Teléfono")),
              TextFormField(controller: _direccionController, decoration: const InputDecoration(labelText: "Dirección")),
              TextFormField(controller: _amountController, decoration: const InputDecoration(labelText: "Monto préstamo")),
              TextFormField(controller: _termController, decoration: const InputDecoration(labelText: "Plazo (20,25,30 días)")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await provider.addClientAndLoan(
                      _nameController.text,
                      _emailController.text,
                      _phoneController.text,
                      _direccionController.text,
                      int.parse(_amountController.text),
                      int.parse(_termController.text),
                    );
                    if (provider.error == null) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("Guardar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
