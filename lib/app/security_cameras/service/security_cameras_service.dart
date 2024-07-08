import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class AuthService {
  final String username;
  final String password;

  AuthService({required this.username, required this.password});

  Future<String?> getVideoStreamUrl() async {
    // Assuming the IP is known and the endpoint is fixed
    const streamUrl = 'http://192.168.0.140:19490/?rtspport=19494&tcpport=19486';
    try {
      final authHeader = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final response = await http.get(
        Uri.parse(streamUrl),
        headers: {'Authorization': authHeader},
      );

      if (response.statusCode == 200) {
        return streamUrl; // Return the URL to be used in the video player
      } else {
        print('Failed to access stream: ${response.statusCode}');
        return null;
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }
}
