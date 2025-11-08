import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'customer_profile_screen.dart';

class ManageFingerprintScreen extends StatefulWidget {
  const ManageFingerprintScreen({super.key});

  @override
  State<ManageFingerprintScreen> createState() =>
      _ManageFingerprintScreenState();
}

class _ManageFingerprintScreenState extends State<ManageFingerprintScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _fingerprintEnabled = false;
  bool _isAuthenticating = false;
  String _statusMessage = "Fingerprint login is disabled.";

  Future<void> _authenticateFingerprint() async {
    try {
      setState(() {
        _isAuthenticating = true;
        _statusMessage = "Authenticating...";
      });

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to enable fingerprint login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticating = false;
        if (didAuthenticate) {
          _fingerprintEnabled = true;
          _statusMessage = "✅ Fingerprint login is enabled.";
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fingerprint verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          _fingerprintEnabled = false;
          _statusMessage = "❌ Authentication failed or cancelled.";
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed!'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _statusMessage =
        "⚠️ Biometric authentication not available on this device.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fingerprint authentication not available.'),
          backgroundColor: Colors.orange,
        ),
      );
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
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Manage Fingerprint Login",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                    'Secure your login using fingerprint authentication.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // 🔐 Fingerprint Authentication Card
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.fingerprint,
                        color: accentColor, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _isAuthenticating
                        ? const CircularProgressIndicator(color: accentColor)
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                      ),
                      onPressed: _authenticateFingerprint,
                      child: const Text(
                        "Scan Fingerprint",
                        style: TextStyle(
                            color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🔘 Save Settings Button
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _fingerprintEnabled
                              ? '✅ Fingerprint login enabled successfully!'
                              : '❌ Fingerprint login remains disabled.',
                        ),
                        backgroundColor: _fingerprintEnabled
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const CustomerProfileScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
