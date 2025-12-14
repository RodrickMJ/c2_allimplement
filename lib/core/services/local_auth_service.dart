// core/services/local_auth_service.dart
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static final LocalAuthentication _auth = LocalAuthentication();

  // Verifica si hay biometría disponible
  static Future<bool> canAuthenticate() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool supported = await _auth.isDeviceSupported();
      return canCheck || supported;
    } catch (e) {
      return false;
    }
  }

  // Intentar autenticar con biometría
  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Usa tu huella o rostro para iniciar sesión rápidamente',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: false, // Permite PIN si no hay biometría
        ),
      );
    } catch (e) {
      print('Error en autenticación biométrica: $e');
      return false;
    }
  }

  // Guardar preferencia: usuario quiere usar biometría
  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, enabled);
  }

  // Ver si el usuario activó la biometría
  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  // Limpiar al hacer logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBiometricEnabled);
  }
}