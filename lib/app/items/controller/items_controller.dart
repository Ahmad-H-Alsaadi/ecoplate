import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemsController {
  final NavigationController navigationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ItemsController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  Future<void> addItem(ItemsModel item) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    try {
      final batch = _firestore.batch();

      // Add or update item in the 'items' collection
      DocumentReference itemDocRef =
          _firestore.collection('users').doc(user.uid).collection('items').doc(item.itemName);

      batch.set(itemDocRef, item.toFirestore(), SetOptions(merge: true));

      // Check if the item already exists in the 'stock' collection
      QuerySnapshot existingStock = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stock')
          .where('item.itemName', isEqualTo: item.itemName)
          .limit(1)
          .get();

      if (existingStock.docs.isNotEmpty) {
        // Update existing stock item
        DocumentReference stockDocRef = existingStock.docs.first.reference;
        batch.update(stockDocRef, {
          'item': item.toFirestore(),
        });
      } else {
        // Add new stock item with initial amount 0
        DocumentReference stockDocRef = _firestore.collection('users').doc(user.uid).collection('stock').doc();

        batch.set(stockDocRef, {
          'id': stockDocRef.id,
          'item': item.toFirestore(),
          'amount': 0,
          'expireDate': null, // You might want to set a default expire date or leave it null
        });
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  Future<List<ItemsModel>> getItems() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    try {
      QuerySnapshot itemsSnapshot = await _firestore.collection('users').doc(user.uid).collection('items').get();

      return itemsSnapshot.docs.map((doc) => ItemsModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching items: $e');
      rethrow;
    }
  }
}
