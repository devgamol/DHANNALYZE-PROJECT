import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customer_signup_screen.dart'; // ✅ for "Sign Up" navigation
import 'customer_dashboard_screen.dart'; // ✅ for successful login navigation

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFF11121A);
    const cardColor = Color(0xFF1C1E27);
    const accentColor = Color(0xFF5E63FF);
    const textColor = Colors.white;
    const secondaryText = Colors.white70;

    return Scaffold(
      backgroundColor: baseColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 🖼️ Logo + Title
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 90,
                      width: 90,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Dhannalyze',
                      style: GoogleFonts.montserrat(
                        color: accentColor,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Smart. Secure. Simplified.',
                      style: GoogleFonts.poppins(
                        color: secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // 🧾 Email Field
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: textColor, fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(color: secondaryText),
                      prefixIcon: Icon(Icons.email_outlined, color: accentColor),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // 🔘 Send OTP Button
                !_isOtpSent
                    ? SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);

                        // Simulate sending OTP
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            _isLoading = false;
                            _isOtpSent = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('OTP sent to your email!'),
                            ),
                          );
                        });
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                        color: Colors.white)
                        : const Text(
                      'Send OTP',
                      style: TextStyle(
                          color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
                    : const SizedBox(),

                // 🔢 OTP Field (only visible after Send OTP)
                if (_isOtpSent) ...[
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: textColor, fontSize: 16),
                      decoration: const InputDecoration(
                        labelText: 'Enter OTP',
                        labelStyle: TextStyle(color: secondaryText),
                        prefixIcon:
                        Icon(Icons.lock_outline, color: accentColor),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        if (value.length != 5) {
                          return 'OTP must be 5 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🔘 Verify OTP Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final enteredOtp = _otpController.text.trim();

                          if (enteredOtp == '12345') {
                            // ✅ Dummy OTP success
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('OTP Verified! Logging in...'),
                              ),
                            );

                            // Navigate to dashboard
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const CustomerDashboardScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid OTP! Please try again.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Verify OTP',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 25),

                // 🔄 No Account? Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account? ",
                      style: TextStyle(color: secondaryText),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const CustomerSignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: accentColor,
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
    );
  }
}
