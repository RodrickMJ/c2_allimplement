import '../entities/user.dart';
import '../repository/auth_repository.dart';

class Login {
  final AuthRepository repository;
  Login(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
