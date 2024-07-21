// lib/core/services/detection_service.dart

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class DetectionService {
  final String apiUrl = 'http://10.0.2.2:5000'; // Use this for Android emulator
  // final String apiUrl = 'http://localhost:5000'; // Use this for iOS simulator
  // final String apiUrl = 'https://your-deployed-url.com'; // Use this for production

  Future<String> detectImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/detect_image'));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedData = json.decode(responseData);
        return decodedData['result'];
      } else {
        throw Exception('Failed to detect image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in detectImage: $e');
      return 'Error: $e';
    }
  }

  String getVideoFeedUrl() {
    return '$apiUrl/video_feed';
  }
}
