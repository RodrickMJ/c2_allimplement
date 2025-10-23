import '../entities/user.dart';
import '../repository/auth_repository.dart';

class Register {
  final AuthRepository repository;
  Register(this.repository);

  Future<User> call(String name, String email, String password) {
    return repository.register(name, email, password);
  }
}
