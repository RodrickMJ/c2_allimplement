// features/auth/presentation/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecase/login.dart';
import '../../domain/usecase/register.dart';
import '../../../../core/services/local_auth_service.dart';  // ← Nuevo import

class AuthProvider with ChangeNotifier {
  final Login loginUseCase;
  final Register registerUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
  });

  User? _user;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await loginUseCase(email, password);

      // ← ¡Activamos biometría después de login exitoso!
      await LocalAuthService.setBiometricEnabled(true);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await registerUseCase(name, email, password);

      // ← ¡Activamos biometría después de registro exitoso!
      await LocalAuthService.setBiometricEnabled(true);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _error = null;

    // ← Limpiamos la preferencia biométrica al cerrar sesión
    await LocalAuthService.clear();

    notifyListeners();
  }
}