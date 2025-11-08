class Loan {
  final String id;
  final String bankName;
  final double amount;
  final DateTime issuedOn;
  final String duration;
  final String interestRate;
  final String paymentHistory;
  final String penalty;
  final String status;

  Loan({
    required this.id,
    required this.bankName,
    required this.amount,
    required this.issuedOn,
    required this.duration,
    required this.interestRate,
    required this.paymentHistory,
    required this.penalty,
    required this.status,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['_id'] ?? '',
      bankName: json['bankName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      issuedOn: DateTime.tryParse(json['issuedOn'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? '',
      interestRate: json['interestRate'] ?? '',
      paymentHistory: json['paymentHistory'] ?? '',
      penalty: json['penalty'] ?? 'NO',
      status: json['status'] ?? 'Active',
    );
  }
}
