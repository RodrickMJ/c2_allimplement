import '../entities/client.dart';

abstract class ClientRepository {
  Future<List<Client>> getClients();
  Future<Client> createClientAndLoan({
    required String name,
    required String email,
    required String phone,
    required String direccion,
    required int amount,
    required int term,
  });
  Future<void> deleteClient(String id);
}
