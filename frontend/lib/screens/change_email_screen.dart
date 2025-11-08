import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/email_service.dart';
import 'customer_profile_screen.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final ChangeEmailService _changeEmailService = ChangeEmailService();

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
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Change Email",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Update your registered email',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // 📧 Email Input Field
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: textColor, fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: 'Enter New Email',
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

                const SizedBox(height: 20),

                // 🔘 Send OTP Button
                if (!_isOtpSent)
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          try {
                            await _changeEmailService
                                .sendOtpToNewEmail(_emailController.text.trim());
                            setState(() {
                              _isLoading = false;
                              _isOtpSent = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('OTP sent to your new email!')),
                            );
                          } catch (e) {
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Send OTP',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),

                // 🔢 OTP Input (after Send OTP)
                if (_isOtpSent) ...[
                  const SizedBox(height: 20),
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
                        if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ✅ Verify OTP Button
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await _changeEmailService.verifyOtpAndUpdateEmail(
                              _emailController.text.trim(),
                              _otpController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text('Email successfully updated!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const CustomerProfileScreen(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Verify & Update',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
