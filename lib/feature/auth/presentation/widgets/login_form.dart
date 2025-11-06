// features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final bool loading;
  final String? error;
  final Function(String email, String pass) onLogin;
  final VoidCallback onRegisterTap;

  const LoginForm({
    super.key,
    required this.loading,
    required this.error,
    required this.onLogin,
    required this.onRegisterTap,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "App de Jhon",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),

        TextField(
          controller: _emailCtrl,
          decoration: const InputDecoration(labelText: "Email"),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: _passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Contraseña"),
        ),

        const SizedBox(height: 16),

        if (widget.error != null)
          Text(
            widget.error!,
            style: TextStyle(color: theme.colorScheme.error),
          ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.loading
                ? null
                : () => widget.onLogin(
                      _emailCtrl.text.trim(),
                      _passCtrl.text.trim(),
                    ),
            child: widget.loading
                ? const CircularProgressIndicator()
                : const Text("Iniciar Sesión"),
          ),
        ),

        TextButton(
          onPressed: widget.onRegisterTap,
          child: const Text("¿No tienes cuenta? Regístrate"),
        ),
      ],
    );
  }
}
