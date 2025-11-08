import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../constants/app_colors.dart';
import '../models/loan.dart';
import '../services/loan_service.dart';

class CustomerLoanScreen extends StatefulWidget {
  const CustomerLoanScreen({super.key});

  @override
  State<CustomerLoanScreen> createState() => _CustomerLoanScreenState();
}

class _CustomerLoanScreenState extends State<CustomerLoanScreen> {
  late Future<List<Loan>> _loansFuture;
  final LoanService _loanService = LoanService();

  @override
  void initState() {
    super.initState();
    _loansFuture = _loanService.getLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Loan>>(
            future: _loansFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.accent));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No loans found.",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              final loans = snapshot.data!;

              final activeLoans =
                  loans.where((l) => l.status == "Active").length;
              final closedLoans =
                  loans.where((l) => l.status == "Inactive").length;
              final totalBorrowed =
              loans.fold<double>(0, (sum, l) => sum + l.amount);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Loan Details",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white10,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo_symbol.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}, "
                              "${TimeOfDay.now().format(context)}",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Summary section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SummaryCard(
                            title: "Active Loans", value: "$activeLoans"),
                        SummaryCard(
                            title: "Closed Loans", value: "$closedLoans"),
                        SummaryCard(
                            title: "Total Borrowed",
                            value: "₹ ${totalBorrowed.toStringAsFixed(0)}"),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Loan cards
                    for (var loan in loans) ...[
                      LoanCard(
                        bankName: loan.bankName,
                        amount: "₹ ${loan.amount.toStringAsFixed(0)}",
                        issuedOn:
                        "${loan.issuedOn.day}/${loan.issuedOn.month}/${loan.issuedOn.year}",
                        duration: loan.duration,
                        interest: loan.interestRate,
                        paymentHistory: loan.paymentHistory,
                        penalty: loan.penalty,
                        status: loan.status,
                      ),
                      const SizedBox(height: 12),
                    ],

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "⚠️ Never share your loan or account details with anyone. "
                            "All financial transactions are traceable and subject to audit. "
                            "Report any suspicious requests to your bank immediately.",
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 2),
    );
  }
}

// Summary Card widget
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const SummaryCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Loan card widget
class LoanCard extends StatelessWidget {
  final String bankName;
  final String amount;
  final String issuedOn;
  final String duration;
  final String interest;
  final String paymentHistory;
  final String penalty;
  final String status;

  const LoanCard({
    super.key,
    required this.bankName,
    required this.amount,
    required this.issuedOn,
    required this.duration,
    required this.interest,
    required this.paymentHistory,
    required this.penalty,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == "active";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E3E),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bankName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildInfoRow("Amount", amount, "Issued On", issuedOn),
                const SizedBox(height: 8),
                _buildInfoRow("Duration", duration, "Interest Rate", interest),
                const SizedBox(height: 8),
                _buildInfoRow("Payment History", paymentHistory, "Penalty", penalty),
              ],
            ),
          ),
        ],
      ),
      );
  }

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "$label1: $value1",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            "$label2: $value2",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
