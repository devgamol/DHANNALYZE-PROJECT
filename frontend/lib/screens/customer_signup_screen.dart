import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'customer_login_screen.dart';

class CustomerSignupScreen extends StatefulWidget {
  const CustomerSignupScreen({super.key});

  @override
  State<CustomerSignupScreen> createState() => _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends State<CustomerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _panController.dispose();
    _aadhaarController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Same logic as main.dart — keeps icons visible across all devices
    final isDarkMode =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.base,
      statusBarIconBrightness:
      isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness:
      isDarkMode ? Brightness.dark : Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content section
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Logo + App Title
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 80,
                            width: 80,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Dhannalyze',
                            style: GoogleFonts.montserrat(
                              color: AppColors.accent,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Smart. Secure. Simplified.',
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Customer Registration',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // PAN Field
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _panController,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'PAN Number',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                            prefixIcon:
                            Icon(Icons.credit_card, color: AppColors.accent),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your PAN number';
                            }
                            if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
                                .hasMatch(value.toUpperCase())) {
                              return 'Enter a valid PAN (e.g., ABCDE1234F)';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Aadhaar Field
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _aadhaarController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Aadhaar Number',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                            prefixIcon:
                            Icon(Icons.perm_identity, color: AppColors.accent),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Aadhaar number';
                            }
                            if (value.length != 12 ||
                                !RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Aadhaar must be a 12-digit number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Email Field
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Email ID',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                            prefixIcon:
                            Icon(Icons.email_outlined, color: AppColors.accent),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email ID';
                            }
                            if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Continue Button
                      _isLoading
                          ? const CircularProgressIndicator(color: AppColors.accent)
                          : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final pan =
                              _panController.text.trim().toUpperCase();
                              final aadhaar = _aadhaarController.text.trim();
                              final email = _emailController.text.trim();

                              final isLinked = pan == 'ABCDE1234F' &&
                                  aadhaar == '123456789012' &&
                                  email.isNotEmpty;

                              if (isLinked) {
                                setState(() => _isLoading = true);
                                Future.delayed(const Duration(seconds: 2), () {
                                  setState(() => _isLoading = false);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const CustomerLoginScreen(),
                                    ),
                                  );
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Invalid or unlinked Email, PAN, or Aadhaar.',
                                    ),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Continue',
                            style:
                            TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Already Registered
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const CustomerLoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed Footer (like dashboard & loan screens)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Text(
                " ⚠️ Your email must be linked with your Aadhaar and PAN for registration.",
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
    );
  }
}
