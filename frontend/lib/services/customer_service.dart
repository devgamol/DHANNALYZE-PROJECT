import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/customer_profile.dart';

class CustomerService {
  static const String baseUrl = "http://192.168.29.41:3000/api/users"; //  fixed route
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<CustomerProfile> getProfile() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt_token');

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


  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }


}
