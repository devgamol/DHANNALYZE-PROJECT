import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../constants/app_colors.dart';

class CustomerAccountsScreen extends StatelessWidget {
  const CustomerAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------
                // PAGE TITLE
                // ---------------------------------------
                Center(
                  child: Text(
                    'Accounts Details',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------------------------------------
                // HEADER ROW → LOGO
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
                // BANK ACCOUNT CARDS SECTION
                // ---------------------------------------
                const BankAccountCard(
                  bankName: "State Bank of India",
                  status: "Active",
                  statusColor: Colors.green,
                  openingDate: "05/04/2020",
                  accountType: "Savings",
                  branch: "Kopar Khairane",
                  linkedServices: "Yes",
                ),
                const SizedBox(height: 15),

                const BankAccountCard(
                  bankName: "ICICI Bank",
                  status: "Inactive",
                  statusColor: Colors.redAccent,
                  openingDate: "24/08/2021",
                  accountType: "Current",
                  branch: "Turbhe",
                  linkedServices: "Yes",
                ),
                const SizedBox(height: 15),

                const BankAccountCard(
                  bankName: "Federal Bank",
                  status: "Active",
                  statusColor: Colors.green,
                  openingDate: "25/07/2019",
                  accountType: "Savings",
                  branch: "Vashi",
                  linkedServices: "Yes",
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 1),
    );
  }
}

// -------------------------------------------------------------
// COMPONENT: Individual Bank Account Card
// -------------------------------------------------------------
class BankAccountCard extends StatelessWidget {
  final String bankName;
  final String status;
  final Color statusColor;
  final String openingDate;
  final String accountType;
  final String branch;
  final String linkedServices;

  const BankAccountCard({
    super.key,
    required this.bankName,
    required this.status,
    required this.statusColor,
    required this.openingDate,
    required this.accountType,
    required this.branch,
    required this.linkedServices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bankName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                "Account Status: ",
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Icon(Icons.circle, color: statusColor, size: 12),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Opening Date: $openingDate",
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            "Account Type: $accountType",
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            "Branch: $branch",
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            "Linked Services: $linkedServices",
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
