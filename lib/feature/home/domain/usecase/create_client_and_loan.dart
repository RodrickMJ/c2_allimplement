import '../entities/client.dart';
import '../repository/client_repository.dart';

class CreateClientAndLoan {
  final ClientRepository repository;

  CreateClientAndLoan(this.repository);

  Future<Client> call({
    required String name,
    required String email,
    required String phone,
    required String direccion,
    required int amount,
    required int term,
  }) {
    return repository.createClientAndLoan(
      name: name,
      email: email,
      phone: phone,
      direccion: direccion,
      amount: amount,
      term: term,
    );
  }
}
