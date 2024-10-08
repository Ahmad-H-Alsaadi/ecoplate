import 'dart:convert';

import 'package:ecoplate/core/controllers/navigation_controller.dart';

class QrCodeController {
  final NavigationController navigationController;
  QrCodeController(this.navigationController);
  static Map<String, dynamic> decodeQrCode(String rawData) {
    try {
      List<int> decodedBytes = base64.decode(rawData);
      String decodedString = utf8.decode(decodedBytes);
      List<String> parts = decodedString.split(RegExp(r'[\x00-\x1F\x7F]'));
      parts = parts.where((part) => part.isNotEmpty).toList();
      Map<String, dynamic> result = {
        'seller_name': parts.isNotEmpty ? parts[0] : 'N/A',
        'vat_number': parts.length > 1 ? parts[1] : 'N/A',
        'timestamp': parts.length > 2 ? parts[2] : 'N/A',
        'total_amount': parts.length > 3 ? parts[3] : 'N/A',
        'vat_amount': parts.length > 4 ? parts[4] : 'N/A',
      };
      for (int i = 5; i < parts.length; i++) {
        result['additionalinfo${i - 4}'] = parts[i];
      }
      return result;
    } on FormatException catch (e) {
      print('Format error: $e');
      return {'error': 'Invalid QR code format: ${e.toString()}'};
    } catch (e) {
      print('Error decoding QR code: $e');
      return {'error': 'Failed to decode QR code: ${e.toString()}'};
    }
  }

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }
}
