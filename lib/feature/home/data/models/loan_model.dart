import '../../domain/entities/loan.dart';

class LoanModel extends Loan {
  LoanModel({
    required super.id,
    required super.clientId,
    required super.amount,
    required super.term,
    required super.interestRate,
    required super.dailyPayment,
    required super.totalToPay,
    required super.status,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] ?? '',
      clientId: json['clientId'] ?? '',
      amount: json['amount'] ?? 0,
      term: json['term'] ?? 0,
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0.0,
      dailyPayment: (json['dailyPayment'] as num?)?.toDouble() ?? 0.0,
      totalToPay: (json['totalToPay'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
    );
  }
}
