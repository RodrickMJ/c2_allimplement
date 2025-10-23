import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/http_client.dart';
import '../models/user_model.dart';

abstract class ServiceAuth {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
}

class ServiceAuthImpl implements ServiceAuth {
  final http.Client client;
  ServiceAuthImpl({http.Client? client}) : client = client ?? HttpClient().client;

  final baseUrl = "https://aspas.space/auth";

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse("$baseUrl/access"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error en login: ${response.body}");
    }

    final decoded = json.decode(response.body);
    return UserModel.fromJson(decoded["data"]);
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse("$baseUrl/create"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error en registro: ${response.body}");
    }

    final decoded = json.decode(response.body);
    return UserModel.fromJson(decoded["data"]);
  }
}
