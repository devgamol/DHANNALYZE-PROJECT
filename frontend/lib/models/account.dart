class Account {
  final String id;
  final String bankName;
  final String accountType;
  final String branch;
  final DateTime openingDate;
  final String status;
  final bool linkedServices;

  Account({
    required this.id,
    required this.bankName,
    required this.accountType,
    required this.branch,
    required this.openingDate,
    required this.status,
    required this.linkedServices,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['_id'] ?? '',
      bankName: json['bankName'] ?? '',
      accountType: json['accountType'] ?? '',
      branch: json['branch'] ?? '',
      openingDate: DateTime.tryParse(json['openingDate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Active',
      linkedServices: json['linkedServices'] ?? true,
    );
  }
}
