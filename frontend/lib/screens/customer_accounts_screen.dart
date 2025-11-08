import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../constants/app_colors.dart';
import '../models/account.dart';
import '../services/account_service.dart';

class CustomerAccountsScreen extends StatefulWidget {
  const CustomerAccountsScreen({super.key});

  @override
  State<CustomerAccountsScreen> createState() => _CustomerAccountsScreenState();
}

class _CustomerAccountsScreenState extends State<CustomerAccountsScreen> {
  late Future<List<Account>> _accountsFuture;
  final AccountService _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    _accountsFuture = _accountService.getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: FutureBuilder<List<Account>>(
            future: _accountsFuture,
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
                    "No accounts found.",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              final accounts = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
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

                    // Dynamically list all accounts
                    for (var acc in accounts) ...[
                      BankAccountCard(
                        bankName: acc.bankName,
                        status: acc.status,
                        statusColor: acc.status == "Active"
                            ? Colors.green
                            : Colors.redAccent,
                        openingDate:
                        "${acc.openingDate.day}/${acc.openingDate.month}/${acc.openingDate.year}",
                        accountType: acc.accountType,
                        branch: acc.branch,
                        linkedServices:
                        acc.linkedServices ? "Yes" : "No",
                      ),
                      const SizedBox(height: 15),
                    ],
                  ],
                ),
              );
            },
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
