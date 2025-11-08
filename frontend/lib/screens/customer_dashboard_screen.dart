import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../constants/app_colors.dart';
import '../models/customer_profile.dart';
import '../services/customer_service.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  late Future<CustomerProfile> _customerFuture;
  final CustomerService _customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    _customerFuture = _customerService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: FutureBuilder<CustomerProfile>(
            future: _customerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child:
                  CircularProgressIndicator(color: AppColors.accent),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    "No data available.",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              final customer = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Center(
                      child: Text(
                        "Dashboard",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Top bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white10,
                          child: Image.asset(
                            'assets/images/logo_symbol.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
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

                    // Customer info card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoText(label: "Email", value: customer.email),
                          InfoText(label: "PAN", value: customer.pan),
                          InfoText(label: "Aadhaar", value: customer.aadhaar),
                          InfoText(
                            label: "2FA Enabled",
                            value:
                            customer.twoFAEnabled ? "Yes" : "No",
                            valueColor: customer.twoFAEnabled
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Dashboard cards (static placeholders)
                    const DashboardCard(
                      icon: Icons.link,
                      title: "Linked Services",
                      value: "Active",
                      valueColor: AppColors.success,
                    ),
                    const SizedBox(height: 12),
                    const DashboardCard(
                      icon: Icons.account_balance,
                      title: "Accounts",
                      value: "2 Active Accounts",
                      valueColor: AppColors.success,
                    ),
                    const SizedBox(height: 12),
                    const DashboardCard(
                      icon: Icons.trending_up,
                      title: "Credit Score",
                      value: "768 (Good)",
                      valueColor: AppColors.success,
                    ),
                    const SizedBox(height: 25),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "⚠️ Never share your personal or banking information with anyone claiming to represent the bank.",
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 13,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
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
      bottomNavigationBar: const AppNavigationBar(currentIndex: 0),
    );
  }
}

// -------------------------------------------------------------
// REUSABLE WIDGETS
// -------------------------------------------------------------
class InfoText extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoText({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        "$label: $value",
        style: TextStyle(
          color: valueColor ?? AppColors.textPrimary,
          fontSize: 15,
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
