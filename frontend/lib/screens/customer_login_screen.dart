import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../services/auth_service.dart';
import '../services/customer_service.dart';
import '../models/auth_response.dart';
import '../models/otp_response.dart';
import 'customer_signup_screen.dart';
import 'customer_dashboard_screen.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final _authService = AuthService();
  final _customerService = CustomerService();
  final _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _biometricPromptShown = false;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim().toLowerCase();
    setState(() => _isLoading = true);

    try {
      final OtpResponse response = await _authService.sendLoginOtp(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));
      if (mounted) setState(() => _isOtpSent = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim().toLowerCase();
    final otp = _otpController.text.trim();

    setState(() => _isLoading = true);

    try {
      final AuthResponse response =
      await _authService.verifyLoginOtp(email, otp);
      await _storage.write(key: 'jwt_token', value: response.token);

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));

      final profile = await _customerService.getProfile();

      if (profile.twoFAEnabled && !_biometricPromptShown) {
        _biometricPromptShown = true;

        try {
          final canCheck = await _localAuth.canCheckBiometrics;
          final available = await _localAuth.getAvailableBiometrics();

          if (!canCheck || available.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                Text('Fingerprint not available — skipping fingerprint verification.'),
                backgroundColor: Colors.orangeAccent,
              ),
            );
          } else {
            final didAuthenticate = await _localAuth.authenticate(
              localizedReason: 'Verify your fingerprint to continue',
              options: const AuthenticationOptions(
                biometricOnly: true,
                stickyAuth: true,
              ),
            );

            if (!didAuthenticate) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fingerprint verification failed'),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }
          }
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fingerprint error: $e'),
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                Image.asset('assets/images/logo.png', height: 90, width: 90),
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
                const SizedBox(height: 50),

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
                const SizedBox(height: 20),

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
                      onPressed: _isLoading ? null : _sendOtp,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Send OTP',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                else ...[
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
                  const SizedBox(height: 25),

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
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Verify OTP',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 25),

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
                              const CustomerSignupScreen()),
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
