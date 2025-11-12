import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/account.dart';

class AccountService {
  static const String baseUrl = "https://dhannalyze-backend-1.onrender.com/api/accounts";
  final _storage = const FlutterSecureStorage();

  // Fetch all accounts for logged-in user
  Future<List<Account>> getAccounts() async {
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
      return data.map((json) => Account.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch accounts: ${response.body}");
    }
  }
}
