import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/service_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ServiceAuth service;

  AuthRepositoryImpl(this.service);

  @override
  Future<User> login(String email, String password) {
    return service.login(email, password);
  }

  @override
  Future<User> register(String name, String email, String password) {
    return service.register(name, email, password);
  }
}
