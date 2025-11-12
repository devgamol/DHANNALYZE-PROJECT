import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/otp_response.dart';

class AuthService {
  static const String baseUrl = "https://dhannalyze-backend-1.onrender.com/api/auth";

  // SIGNUP API
  
  Future<OtpResponse> signup({
    required String pan,
    required String aadhaar,
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/signup');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pan': pan,
          'aadhaar': aadhaar,
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return OtpResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('Error during signup: $e');
    }
  }

  // SEND OTP API (Login)
  
  Future<OtpResponse> sendLoginOtp(String email) async {
    final url = Uri.parse('$baseUrl/login/send-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return OtpResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      throw Exception('Error sending OTP: $e');
    }
  }

  // VERIFY OTP API (Login)

  Future<AuthResponse> verifyLoginOtp(String email, String otp) async {
    final url = Uri.parse('$baseUrl/login/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }
}
