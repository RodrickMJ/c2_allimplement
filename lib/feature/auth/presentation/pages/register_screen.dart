// features/auth/presentation/pages/register_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _anim;

  @override void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim.forward();
  }

  @override void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: FadeTransition(
        opacity: _anim,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Crear Cuenta", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),

                // Nombre
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: "Nombre completo",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) => v?.trim().isEmpty == true ? "Requerido" : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (v) {
                    if (v?.trim().isEmpty == true) return "Requerido";
                    if (!v!.contains('@')) return "Email inválido";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Contraseña
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (v) => v?.length == 0 ? "Requerido" : v!.length < 6 ? "Mínimo 6 caracteres" : null,
                ),
                const SizedBox(height: 16),

                if (auth.error != null)
                  Text(auth.error!, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.loading ? null : () => _register(auth),
                    child: auth.loading ? const CircularProgressIndicator() : const Text("Registrarse"),
                  ),
                ),

                TextButton(
                  onPressed: () => context.goNamed(AppRoutes.login),
                  child: const Text("¿Ya tienes cuenta? Inicia sesión"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register(AuthProvider auth) async {
    if (_formKey.currentState!.validate()) {
      await auth.register(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
    }
  }
}