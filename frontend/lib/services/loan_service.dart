import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/loan.dart';

class LoanService {
  static const String baseUrl = "https://dhannalyze-backend-1.onrender.com/api/loans";
  final _storage = const FlutterSecureStorage();

  // Fetch all loans for logged-in customer
  Future<List<Loan>> getLoans() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception("No token found. Please log in again.");
    }

    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Loan.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch loans: ${response.body}");
    }
  }
}
