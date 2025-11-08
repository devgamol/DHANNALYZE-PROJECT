import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../constants/app_colors.dart';
import 'customer_login_screen.dart';
import 'change_email_screen.dart';
import 'manage_fingerprint_screen.dart';
import '../models/customer_profile.dart';
import '../services/customer_service.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final CustomerService _customerService = CustomerService();
  late Future<Map<String, dynamic>> _combinedFuture;

  @override
  void initState() {
    super.initState();
    _combinedFuture = _loadAllData();
  }

  Future<Map<String, dynamic>> _loadAllData() async {
    final profile = await _customerService.getProfile();
    final accountsCount = await _customerService.getAccountsCount();
    final loansCount = await _customerService.getLoansCount();

    return {
      'profile': profile,
      'accountsCount': accountsCount,
      'loansCount': loansCount,
    };
  }

  void _logout(BuildContext context) async {
    await _customerService.logout();
    if (!mounted) return;

    // Clear navigation history and data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CustomerLoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _combinedFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
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
                    "Profile not found.",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              final profile = snapshot.data!['profile'] as CustomerProfile;
              final accountsCount = snapshot.data!['accountsCount'] as int;
              final loansCount = snapshot.data!['loansCount'] as int;

              return Column(
                children: [
                  const SizedBox(height: 10),

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
                  const SizedBox(height: 24),

                  // Dynamic User Info Card
                  Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email: ${profile.email}",
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "2FA Enabled: ${profile.twoFAEnabled ? "Yes" : "No"}",
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Linked Accounts: $accountsCount",
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Active Loan Accounts: $loansCount",
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 16),
                        ),
                      ],
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
                          leading: const Icon(Icons.email_outlined,
                              color: AppColors.textPrimary),
                          title: const Text(
                            'Change Email',
                            style: TextStyle(
                                color: AppColors.textPrimary, fontSize: 16),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const ChangeEmailScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(color: Colors.grey, indent: 15, endIndent: 15),
                        ListTile(
                          leading: const Icon(Icons.fingerprint,
                              color: AppColors.textPrimary),
                          title: const Text(
                            'Manage Fingerprint Login',
                            style: TextStyle(
                                color: AppColors.textPrimary, fontSize: 16),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const ManageFingerprintScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Logout Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () => _logout(context),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 3),
    );
  }
}
