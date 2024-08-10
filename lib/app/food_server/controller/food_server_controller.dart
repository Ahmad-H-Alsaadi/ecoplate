import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodServerController {
  final NavigationController navigationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FoodServerController(
    this.navigationController, {
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  });

  Stream<List<ProductsModel>> getAllProducts() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
    return _firestore.collection('users').doc(user.uid).collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return ProductsModel.fromFirestore(doc);
            } catch (e) {
              print('Error parsing product: ${doc.id}, Error: $e');
              return null;
            }
          })
          .whereType<ProductsModel>()
          .toList();
    });
  }

  Future<void> saveOrder(List<ProductsModel> selections, Map<String, int> quantities) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('Error: No user logged in');
        return;
      }

      print('Starting saveOrder process for user: ${user.uid}');

      final batch = _firestore.batch();

      DocumentReference orderRef = _firestore.collection('users').doc(user.uid).collection('orders').doc();
      batch.set(orderRef, {
        'createdAt': FieldValue.serverTimestamp(),
        'selections': selections
            .map((s) => {
                  'productName': s.productName,
                  'quantity': quantities[s.productName] ?? 0,
                })
            .toList(),
      });

      print('order document prepared for batch commit');

      QuerySnapshot allStockSnapshot = await _firestore.collection('users').doc(user.uid).collection('stock').get();

      List<StockModel> allStockItems = allStockSnapshot.docs.map((doc) => StockModel.fromFirestore(doc)).toList();

      for (var product in selections) {
        print('processing selection: ${product.productName}');
        int quantity = quantities[product.productName] ?? 0;

        for (var recipeItem in product.recipe) {
          print('processing recipe item: ${recipeItem.item.itemName}');
          double totalAmountNeeded = recipeItem.amount * quantity;

          print('total amount needed: $totalAmountNeeded');

          List<StockModel> relevantStock = allStockItems
              .where((stock) => stock.item.itemName == recipeItem.item.itemName)
              .toList()
            ..sort((a, b) => a.expireDate.compareTo(b.expireDate));

          print('relevant stock items: ${relevantStock.length}');

          double remainingAmountNeeded = totalAmountNeeded;

          for (var stock in relevantStock) {
            if (remainingAmountNeeded <= 0) break;

            double amountToReduce = min(stock.amount, remainingAmountNeeded);
            remainingAmountNeeded -= amountToReduce;

            print('updating stock: ${stock.id}, current amount: ${stock.amount}, reducing by: $amountToReduce');

            if (stock.amount - amountToReduce <= 0.001) {
              batch.delete(_firestore.collection('users').doc(user.uid).collection('stock').doc(stock.id));
              print('deleting stock item: ${stock.id}');
            } else {
              batch.update(_firestore.collection('users').doc(user.uid).collection('stock').doc(stock.id), {
                'amount': FieldValue.increment(-amountToReduce),
              });
              print('updating stock item: ${stock.id}, new amount: ${stock.amount - amountToReduce}');
            }
          }

          if (remainingAmountNeeded > 0.001) {
            print(
                'warning: Not enough stock for ${recipeItem.item.itemName}. needed: $totalAmountNeeded, available: ${totalAmountNeeded - remainingAmountNeeded}');
          }
        }
      }

      print('Committing batch');
      await batch.commit();
      print('Batch committed successfully');
    } catch (e, stackTrace) {
      print('Error in saveOrder: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
