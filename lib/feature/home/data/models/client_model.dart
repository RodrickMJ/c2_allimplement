import '../../domain/entities/client.dart';
import 'loan_model.dart';

class ClientModel extends Client {
  ClientModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.direccion,
    required super.loans,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      direccion: json['direccion'] ?? '',
      loans: (json['loans'] as List<dynamic>? ?? [])
          .map((e) => LoanModel.fromJson(e))
          .toList(),
    );
  }
}
