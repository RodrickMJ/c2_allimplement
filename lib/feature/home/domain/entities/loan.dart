class Loan {
  final String id;
  final String clientId;
  final int amount;
  final int term;
  final double interestRate;
  final double dailyPayment;
  final double totalToPay;
  final String status;

  Loan({
    required this.id,
    required this.clientId,
    required this.amount,
    required this.term,
    required this.interestRate,
    required this.dailyPayment,
    required this.totalToPay,
    required this.status,
  });
}
