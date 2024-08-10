import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/app/purchases/model/purchases_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PurchasesController {
  final NavigationController navigationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PurchasesController(this.navigationController);

  PurchasesModel? decodePurchaseData(String qrCode) {
    try {
      List<String> decodedData = String.fromCharCodes(base64Decode(qrCode)).split('\u001d');
      if (decodedData.length >= 6) {
        String businessName = decodedData[0];
        String vatNumber = decodedData[1];
        DateTime dateTime = DateTime.parse(decodedData[2]);
        double totalAmount = double.parse(decodedData[3]);
        double vatAmount = double.parse(decodedData[4]);

        List<StockModel> items = [];
        if (decodedData.length > 6) {
          List<String> itemsData = decodedData.sublist(5);
          for (String itemData in itemsData) {
            List<String> itemParts = itemData.split(',');
            if (itemParts.length >= 3) {
              items.add(StockModel(
                id: '',
                item: ItemsModel(
                  id: itemParts[0],
                  itemName: itemParts[1],
                  vatNumber: vatNumber,
                  measurement: 'pcs',
                ),
                amount: 1,
                expireDate: DateTime.now().add(const Duration(days: 30)),
              ));
            }
          }
        }

        return PurchasesModel(
          id: '',
          sellerName: businessName,
          vatNumber: vatNumber,
          dateTime: dateTime,
          totalAmount: totalAmount,
          vatAmount: vatAmount,
          items: items,
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

  Future<void> savePurchase(PurchasesModel purchase) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final batch = _firestore.batch();

      final purchaseData = purchase.toFirestore();
      DocumentReference purchaseDocRef = _firestore.collection('users').doc(user.uid).collection('purchases').doc();
      batch.set(purchaseDocRef, purchaseData);
      batch.update(purchaseDocRef, {'id': purchaseDocRef.id});

      for (var stockItem in purchase.items) {
        ItemsModel updatedItem = ItemsModel(
          id: stockItem.item.id,
          itemName: stockItem.item.itemName,
          measurement: stockItem.item.measurement,
          vatNumber: purchase.vatNumber,
        );

        DocumentReference itemDocRef =
            _firestore.collection('users').doc(user.uid).collection('items').doc(updatedItem.itemName);
        batch.set(itemDocRef, updatedItem.toFirestore(), SetOptions(merge: true));

        QuerySnapshot existingStock = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('stock')
            .where('item.itemName', isEqualTo: stockItem.item.itemName)
            .limit(1)
            .get();

        if (existingStock.docs.isNotEmpty) {
          DocumentReference stockDocRef = existingStock.docs.first.reference;
          batch.update(stockDocRef, {
            'amount': FieldValue.increment(stockItem.amount),
            'item.vatNumber': purchase.vatNumber,
            'expireDate': stockItem.expireDate,
          });
        } else {
          DocumentReference stockDocRef = _firestore.collection('users').doc(user.uid).collection('stock').doc();
          batch.set(stockDocRef, {
            ...stockItem.toFirestore(),
            'item': updatedItem.toFirestore(),
            'id': stockDocRef.id,
          });
        }
      }

      await batch.commit();
    } catch (e) {
      print('Error saving purchase and updating stock: $e');
      rethrow;
    }
  }

  Future<List<PurchasesModel>> getUserPurchases() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .orderBy('dateTime', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => PurchasesModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching user purchases: $e');
      rethrow;
    }
  }

  Future<List<StockModel>> getUserStock() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      QuerySnapshot querySnapshot =
          await _firestore.collection('users').doc(user.uid).collection('stock').orderBy('expireDate').get();

      return querySnapshot.docs.map((doc) => StockModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching user stock: $e');
      rethrow;
    }
  }

  Future<List<ItemsModel>> getSavedItems() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      QuerySnapshot querySnapshot = await _firestore.collection('users').doc(user.uid).collection('items').get();
      return querySnapshot.docs.map((doc) => ItemsModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching saved items: $e');
      rethrow;
    }
  }

  Future<void> saveItemIfNotExists(ItemsModel item) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      QuerySnapshot existingItems = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('items')
          .where('vatNumber', isEqualTo: item.vatNumber)
          .limit(1)
          .get();

      if (existingItems.docs.isEmpty) {
        await _firestore.collection('users').doc(user.uid).collection('items').add(item.toFirestore());
      }
    } catch (e) {
      print('Error saving item: $e');
      rethrow;
    }
  }
}
