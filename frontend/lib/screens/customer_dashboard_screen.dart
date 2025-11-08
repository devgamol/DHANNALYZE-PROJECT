import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../constants/app_colors.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,

      // SafeArea ensures the UI doesn’t overlap with system bars or notches
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------
                // PAGE TITLE
                // -------------------------------
                Center(
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

                // -------------------------------
                // TOP ROW → LOGO (LEFT) + TIMESTAMP (RIGHT)
                // -------------------------------
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
                          fit: BoxFit.contain, // ensures full logo fits inside the circle
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

                // -------------------------------
                // CUSTOMER INFO CARD
                // -------------------------------
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoText(label: "Name", value: "Amol Sahu"),
                      InfoText(
                          label: "Email",
                          value: "amolsahu31010@gmail.com"),
                      InfoText(label: "Age", value: "24"),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // -------------------------------
                // DASHBOARD CARDS SECTION
                // -------------------------------
                const DashboardCard(
                  icon: Icons.link,
                  title: "Linked Services",
                  value: "Yes",
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

                // -------------------------------
                // SECURITY WARNING SECTION
                // -------------------------------
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
          ),
        ),
      ),

      // Bottom navigation bar component
      bottomNavigationBar: const AppNavigationBar(currentIndex: 0),
    );
  }
}

// -------------------------------------------------------------
// SMALL REUSABLE COMPONENTS
// -------------------------------------------------------------

/// Displays a single line of label-value information, used in customer info card
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

/// Represents one summary card (e.g., Linked Services, Accounts, Credit Score)
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
