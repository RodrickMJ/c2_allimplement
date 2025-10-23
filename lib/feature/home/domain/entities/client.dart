import 'loan.dart';

class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String direccion;
  final List<Loan> loans;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.direccion,
    required this.loans,
  });
}
