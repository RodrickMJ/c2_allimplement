// features/auth/presentation/pages/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_form.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: FadeTransition(
        opacity: _anim,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LoginForm(
              loading: auth.loading,
              error: auth.error,
              onLogin: (email, pass) {
                context.read<AuthProvider>().login(email, pass);
              },
              onRegisterTap: () => context.goNamed(AppRoutes.register),
            ),
          ),
        ),
      ),
    );
  }
}
