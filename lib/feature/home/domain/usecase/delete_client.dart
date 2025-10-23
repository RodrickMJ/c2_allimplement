import '../repository/client_repository.dart';

class DeleteClient {
  final ClientRepository repository;

  DeleteClient(this.repository);

  Future<void> call(String id) {
    return repository.deleteClient(id);
  }
}
