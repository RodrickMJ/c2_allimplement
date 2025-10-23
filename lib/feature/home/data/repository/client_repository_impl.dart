import '../../domain/entities/client.dart';
import '../../domain/repository/client_repository.dart';
import '../datasource/service_clients.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;

  ClientRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Client>> getClients() {
    return remoteDataSource.getClients();
  }

  @override
  Future<Client> createClientAndLoan({
    required String name,
    required String email,
    required String phone,
    required String direccion,
    required int amount,
    required int term,
  }) {
    return remoteDataSource.createClientAndLoan(
      name: name,
      email: email,
      phone: phone,
      direccion: direccion,
      amount: amount,
      term: term,
    );
  }

  @override
  Future<void> deleteClient(String id) {
    return remoteDataSource.deleteClient(id);
  }
}
