import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../constants/app_colors.dart';

class CustomerLoanScreen extends StatelessWidget {
  const CustomerLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------
              // PAGE TITLE
              // ---------------------------------------
              Center(
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

              // ---------------------------------------
              // HEADER ROW → LOGO + TIMESTAMP
              // ---------------------------------------
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
                    "11/6/2025, 7:59 AM",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // ---------------------------------------
              // LOAN SUMMARY CARDS (Quick Stats)
              // ---------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SummaryCard(title: "Active Loans", value: "1"),
                  SummaryCard(title: "Closed Loans", value: "1"),
                  SummaryCard(title: "Total Borrowed", value: "₹ 15,53,112"),
                ],
              ),
              const SizedBox(height: 25),

              // ---------------------------------------
              // INDIVIDUAL LOAN CARDS
              // ---------------------------------------
              const LoanCard(
                bankName: "Punjab National Bank",
                amount: "₹ 8,43,500",
                issuedOn: "05/12/2023",
                duration: "1 Year",
                interest: "6.2%",
                paymentHistory: "On Time",
                penalty: "NO",
                status: "Active",
              ),
              const SizedBox(height: 12),

              const LoanCard(
                bankName: "State Bank of India",
                amount: "₹ 7,09,612",
                issuedOn: "28/04/2024",
                duration: "6 Months",
                interest: "7.3%",
                paymentHistory: "On Time",
                penalty: "NO",
                status: "Inactive",
              ),
              const SizedBox(height: 25),

              // ---------------------------------------
              // WARNING FOOTER
              // ---------------------------------------
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
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 2),
    );
  }
}

// -------------------------------------------------------------
// SUMMARY CARD (small rectangular metric widget)
// -------------------------------------------------------------
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
  });

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

// -------------------------------------------------------------
// LOAN CARD (Detailed Loan Information)
// -------------------------------------------------------------
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
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E3E),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
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

          // Body Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildInfoRow("Amount", amount, "Issued On", issuedOn),
                const SizedBox(height: 8),
                _buildInfoRow("Duration", duration, "Interest Rate", interest),
                const SizedBox(height: 8),
                _buildInfoRow("Payment History", paymentHistory, "Any Penalty", penalty),
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
