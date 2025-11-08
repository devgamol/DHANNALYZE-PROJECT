import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../services/customer_service.dart';
import 'customer_profile_screen.dart';

class ManageFingerprintScreen extends StatefulWidget {
  const ManageFingerprintScreen({super.key});

  @override
  State<ManageFingerprintScreen> createState() => _ManageFingerprintScreenState();
}

class _ManageFingerprintScreenState extends State<ManageFingerprintScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  final CustomerService _customerService = CustomerService();

  bool _isAuthenticating = false;
  bool _fingerprintEnabled = false;
  String _status = "Fingerprint login is disabled.";

  // Perform fingerprint authentication
  Future<void> _authenticate() async {
    try {
      setState(() {
        _isAuthenticating = true;
        _status = "Authenticating...";
      });

      bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Authenticate to enable fingerprint login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        setState(() {
          _fingerprintEnabled = true;
          _status = "✅ Fingerprint login enabled.";
        });

        // Update status on backend
        await _updateFingerprintStatus(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _status = "❌ Authentication failed or cancelled.";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication failed.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _status = "⚠️ Biometric authentication not available on this device.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fingerprint error: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    } finally {
      setState(() => _isAuthenticating = false);
    }
  }

  // Update fingerprint preference to backend
  Future<void> _updateFingerprintStatus(bool enable) async {
    try {
      final token = await _customerService.getProfile(); // get token from storage
      final response = await _customerService.toggleFingerprint(enable);
      if (response) {
        debugPrint("Fingerprint status updated successfully!");
      }
    } catch (e) {
      debugPrint("Error updating fingerprint status: $e");
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
              // Header
              Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 90, width: 90),
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

              // Fingerprint Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                    const Icon(Icons.fingerprint, color: accentColor, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: textColor, fontSize: 16),
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
                      onPressed: _authenticate,
                      child: const Text(
                        "Scan Fingerprint",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Save button
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomerProfileScreen()),
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
