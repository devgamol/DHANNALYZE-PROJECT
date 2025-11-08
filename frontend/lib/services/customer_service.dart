import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/customer_profile.dart';

class CustomerService {
  static const String baseUrl = "http://192.168.29.41:3000/api/users"; // ✅ Update IP
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // =========================
  // Fetch Customer Profile
  // =========================
  Future<CustomerProfile> getProfile() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception("No token found. Please log in again.");
    }

    final url = Uri.parse('$baseUrl/profile');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CustomerProfile.fromJson(data);
    } else {
      throw Exception("Failed to fetch profile: ${response.statusCode}");
    }
  }

  // =========================
  // Fetch Accounts Count
  // =========================
  Future<int> getAccountsCount() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception("No token found. Please log in again.");
    }

    final url = Uri.parse("http://192.168.29.41:3000/api/accounts");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> accounts = jsonDecode(response.body);
      return accounts.length;
    } else {
      throw Exception("Failed to fetch accounts: ${response.statusCode}");
    }
  }

  // =========================
  // Fetch Loan Count
  // =========================
  Future<int> getLoansCount() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception("No token found. Please log in again.");
    }

    final url = Uri.parse("http://192.168.29.41:3000/api/loans");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> loans = jsonDecode(response.body);
      return loans.length;
    } else {
      throw Exception("Failed to fetch loans: ${response.statusCode}");
    }
  }

  // =========================
  // Fetch Credit Score (via backend API)
  // =========================
  Future<int> getCreditScore() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception("No token found. Please log in again.");
    }

    final url = Uri.parse("http://192.168.29.41:3000/api/creditscore");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // If backend sends score field, use it, else fallback to 0
      if (data is Map && data.containsKey('score')) {
        return (data['score'] ?? 0).toInt();
      } else {
        return 0;
      }
    } else if (response.statusCode == 404) {
      // No score available for user
      return 0;
    } else {
      throw Exception("Failed to fetch credit score: ${response.statusCode}");
    }
  }

  // =========================
  // Toggle Fingerprint Setting
  // =========================
  Future<bool> toggleFingerprint(bool enable) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return false;

    final url = Uri.parse('$baseUrl/fingerprint');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'enable': enable}),
    );

    return response.statusCode == 200;
  }

  // =========================
  // Logout (Clear All Data)
  // =========================
  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
