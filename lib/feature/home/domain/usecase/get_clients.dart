import '../entities/client.dart';
import '../repository/client_repository.dart';

class GetClients {
  final ClientRepository repository;

  GetClients(this.repository);

  Future<List<Client>> call() {
    return repository.getClients();
  }
}
