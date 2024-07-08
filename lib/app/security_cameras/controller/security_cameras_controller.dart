import 'dart:convert';

import 'package:http/http.dart' as http;

class SmartPSSService {
  final String baseUrl;
  final String username;
  final String password;

  SmartPSSService({required this.baseUrl, required this.username, required this.password});

  Future<Map<String, dynamic>> login() async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> getDeviceList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/devices'),
      headers: <String, String>{
        'Authorization': 'Bearer your_token', // Replace with actual token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load devices');
    }
  }
}
