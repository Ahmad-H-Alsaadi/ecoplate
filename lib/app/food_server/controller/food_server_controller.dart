import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/food_server/model/food_server_model.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodServerController {
  final NavigationController navigationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FoodServerController(this.navigationController);

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

  Future<void> saveOrder(List<FoodServerSelection> selections) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final batch = _firestore.batch();
      List<String> missingProducts = [];
      List<String> updatedStockItems = [];

      print('Starting saveOrder process');

      // Save the order
      DocumentReference orderRef = _firestore.collection('users').doc(user.uid).collection('orders').doc();
      batch.set(orderRef, {
        'createdAt': FieldValue.serverTimestamp(),
        'selections': selections.map((s) => s.toJson()).toList(),
      });

      print('Order document created');

      // Update stock
      for (var selection in selections) {
        print('Processing selection: ${selection.productId}');
        DocumentSnapshot productDoc =
            await _firestore.collection('users').doc(user.uid).collection('products').doc(selection.productId).get();

        if (!productDoc.exists) {
          print('Product document does not exist: ${selection.productId}');
          missingProducts.add(selection.productId);
          continue;
        }

        print('Raw product data: ${productDoc.data()}');

        ProductsModel? product;
        try {
          product = ProductsModel.fromFirestore(productDoc);
        } catch (e) {
          print('Error parsing product: $e');
          continue;
        }

        print('Product: ${product.productName}');

        if (product.recipe.isEmpty) {
          print('Product has no recipe items');
          continue;
        }

        for (var recipeItem in product.recipe) {
          print('Processing recipe item: ${recipeItem.item.itemName}');
          double totalAmountNeeded = recipeItem.amount * selection.quantity;

          print('Total amount needed: $totalAmountNeeded');

          QuerySnapshot existingStock = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('stock')
              .where('item.itemName', isEqualTo: recipeItem.item.itemName)
              .orderBy('expireDate')
              .get();

          print('Existing stock items: ${existingStock.docs.length}');

          double remainingAmountNeeded = totalAmountNeeded;

          for (var stockDoc in existingStock.docs) {
            if (remainingAmountNeeded <= 0) break;

            StockModel stock = StockModel.fromFirestore(stockDoc);
            double amountToReduce = stock.amount < remainingAmountNeeded ? stock.amount : remainingAmountNeeded;
            remainingAmountNeeded -= amountToReduce;

            print('Updating stock: ${stock.id}, current amount: ${stock.amount}, reducing by: $amountToReduce');

            if (stock.amount - amountToReduce <= 0) {
              batch.delete(stockDoc.reference);
              print('Deleting stock item: ${stock.id}');
            } else {
              batch.update(stockDoc.reference, {
                'amount': FieldValue.increment(-amountToReduce),
              });
              print('Updating stock item: ${stock.id}, new amount: ${stock.amount - amountToReduce}');
            }
            updatedStockItems.add(stock.id);
          }

          if (remainingAmountNeeded > 0) {
            print(
                'Warning: Not enough stock for ${recipeItem.item.itemName}. Needed: $totalAmountNeeded, Available: ${totalAmountNeeded - remainingAmountNeeded}');
          }
        }
      }

      if (missingProducts.isNotEmpty) {
        print('Warning: The following products were not found: ${missingProducts.join(", ")}');
      }

      print('Committing batch');
      await batch.commit();
      print('Batch committed successfully');

      if (updatedStockItems.isEmpty) {
        print('No stock items were updated. This could be because:');
        print('1. The products do not exist in the database');
        print('2. The products have no recipe items');
        print('3. There is no stock for the recipe items');
      } else {
        print('Updated stock items: ${updatedStockItems.join(", ")}');
      }
    } catch (e, stackTrace) {
      print('Error in saveOrder: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
