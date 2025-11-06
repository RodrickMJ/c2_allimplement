import 'package:flutter/foundation.dart';
import '../../domain/entities/client.dart';
import '../../domain/usecase/get_clients.dart';
import '../../domain/usecase/create_client_and_loan.dart';
import '../../domain/usecase/delete_client.dart';

class ClientsProvider with ChangeNotifier {
  final GetClients getClients;
  final CreateClientAndLoan createClientAndLoan;
  final DeleteClient deleteClient;

  ClientsProvider({
    required this.getClients,
    required this.createClientAndLoan,
    required this.deleteClient,
  });

  List<Client> _clients = [];
  bool _loading = false;
  String? _error;

  List<Client> get clients => _clients;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchClients() async {
    _loading = true;
    notifyListeners();
    try {
      _clients = await getClients();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> addClientAndLoan(
    String name,
    String email,
    String phone,
    String direccion,
    int amount,
    int term,
  ) async {
    _loading = true;
    notifyListeners();

    try {
      final client = await createClientAndLoan(
        name: name,
        email: email,
        phone: phone,
        direccion: direccion,
        amount: amount,
        term: term,
      );

      _clients.add(client);
      _error = null;

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();

      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> removeClient(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deleteClient(id);
      _clients.removeWhere((c) => c.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
