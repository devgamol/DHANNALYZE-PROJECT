import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangeEmailService {
  static const String baseUrl = "https://dhannalyze-backend-1.onrender.com/api/auth";
  final _storage = const FlutterSecureStorage();

  // Step 1: Send OTP to new email
  Future<void> sendOtpToNewEmail(String newEmail) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception("No token found. Please log in again.");

    final url = Uri.parse("$baseUrl/email/change/send-otp");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"newEmail": newEmail}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send OTP: ${response.body}");
    }
  }

  // Step 2: Verify OTP and update email
  Future<void> verifyOtpAndUpdateEmail(String newEmail, String otp) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception("No token found. Please log in again.");

    final url = Uri.parse("$baseUrl/email/change/verify-otp");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"newEmail": newEmail, "otp": otp}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to verify OTP: ${response.body}");
    }
  }
}
