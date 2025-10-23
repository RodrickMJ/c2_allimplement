import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client_model.dart';
import '../models/loan_model.dart';

abstract class ClientRemoteDataSource {
  Future<List<ClientModel>> getClients();
  Future<ClientModel> createClientAndLoan({
    required String name,
    required String email,
    required String phone,
    required String direccion,
    required int amount,
    required int term,
  });
  Future<void> deleteClient(String id);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ClientRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<List<ClientModel>> getClients() async {
    final response = await client.get(Uri.parse('$baseUrl/clients/'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)["data"];
      return data.map((e) => ClientModel.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener clientes");
    }
  }

  @override
  Future<ClientModel> createClientAndLoan({
    required String name,
    required String email,
    required String phone,
    required String direccion,
    required int amount,
    required int term,
  }) async {
    // Crear cliente
    final responseClient = await client.post(
      Uri.parse('$baseUrl/clients/create'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": name,
        "email": email,
        "phone": phone,
        "direccion": direccion,
      }),
    );

    if (responseClient.statusCode != 200 && responseClient.statusCode != 201) {
      throw Exception("Error al crear cliente");
    }

    final clientData = json.decode(responseClient.body)["data"];
    final clientId = clientData["id"];

    // Crear préstamo
    final responseLoan = await client.post(
      Uri.parse('$baseUrl/loans/create'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "clientId": clientId,
        "amount": amount,
        "term": term,
      }),
    );

    if (responseLoan.statusCode != 200 && responseLoan.statusCode != 201) {
      throw Exception("Error al crear préstamo");
    }

    final loanData = LoanModel.fromJson(json.decode(responseLoan.body)["data"]);
    final clientModel = ClientModel.fromJson(clientData);

    return ClientModel(
      id: clientModel.id,
      name: clientModel.name,
      email: clientModel.email,
      phone: clientModel.phone,
      direccion: clientModel.direccion,
      loans: [loanData],
    );
  }

  @override
  Future<void> deleteClient(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/clients/$id'));
    if (response.statusCode != 204) {
      throw Exception("Error al eliminar cliente");
    }
  }
}
