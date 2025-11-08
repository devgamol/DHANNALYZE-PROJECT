import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../constants/app_colors.dart';
import 'customer_login_screen.dart';
import 'change_email_screen.dart';
import 'manage_fingerprint_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Page Title
              const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Logo row
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

              const SizedBox(height: 24),

              // User Info Card
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: Amol Sahu",
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 17),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Email: amolsahu31010@gmail.com",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Linked Accounts: 3",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Primary Bank Account: State Bank of India",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Active Loan Accounts: 2",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Action Options
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email_outlined, color: AppColors.textPrimary),
                      title: const Text(
                        'Change Email',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeEmailScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.grey, indent: 15, endIndent: 15),
                    ListTile(
                      leading: const Icon(Icons.fingerprint, color: AppColors.textPrimary),
                      title: const Text(
                        'Manage Fingerprint Login',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageFingerprintScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Logout Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CustomerLoginScreen()),
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 3),
    );
  }
}
