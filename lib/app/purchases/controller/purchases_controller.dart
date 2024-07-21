import 'dart:convert';
import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/app/purchases/model/purchases_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';

class PurchasesController {
  final NavigationController navigationController;

  PurchasesController(this.navigationController);

  PurchasesModel? decodePurchaseData(String qrCode) {
    try {
      List<String> decodedData = String.fromCharCodes(base64Decode(qrCode)).split('\u001d');
      if (decodedData.length >= 6) {
        // Parse the basic purchase information
        String businessName = decodedData[0];
        String vatNumber = decodedData[1];
        DateTime dateTime = DateTime.parse(decodedData[2]);
        double totalAmount = double.parse(decodedData[3]);
        double vatAmount = double.parse(decodedData[4]);

        // Parse items (assuming they're encoded in the remaining part of the QR code)
        List<ItemsModel> items = [];
        if (decodedData.length > 6) {
          List<String> itemsData = decodedData.sublist(5);
          for (String itemData in itemsData) {
            List<String> itemParts = itemData.split(',');
            if (itemParts.length >= 3) {
              items.add(ItemsModel(
                id: itemParts[0],
                itemName: itemParts[1],
                vatNumber: '',
                measurement: '',
              ));
            }
          }
        }

        return PurchasesModel(
          sellerName: businessName,
          vatNumber: vatNumber,
          dateTime: dateTime,
          totalAmount: totalAmount,
          vatAmount: vatAmount,
          items: [],
          id: '',
        );
      } else {
        print('Invalid QR Code format');
        return null;
      }
    } catch (e) {
      print('Error decoding QR Code: $e');
      return null;
    }
  }

  void navigateTo(String routeName, {PurchasesModel? purchasesModel}) {
    if (purchasesModel != null) {
      navigationController.navigateTo(routeName, arguments: {'purchasesModel': purchasesModel});
    } else {
      navigationController.navigateTo(routeName);
    }
  }
}
