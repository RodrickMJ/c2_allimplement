import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecase/login.dart';
import '../../domain/usecase/register.dart';

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
    notifyListeners();

    try {
      _user = await loginUseCase(email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _loading = true;
    notifyListeners();

    try {
      _user = await registerUseCase(name, email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
