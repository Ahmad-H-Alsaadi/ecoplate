// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecoplate/app/purchases/model/purchases_model.dart';
// import 'package:ecoplate/app/items/model/items_model.dart';
// import 'package:ecoplate/app/stock/model/stock_model.dart';

// class PurchasesService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _usersCollection = 'user';
//   final String _purchasesCollection = 'purchases';
//   final String _itemsCollection = 'items';

//   // Assume we have a way to get the current user's ID
//   final String currentUserId = 'AV0F20OJ7ohi9NEdqeEw'; // Replace with actual user ID retrieval

//   Future<bool> addPurchase(PurchasesModel purchase, List<ItemsModel> items) async {
//     final batch = _firestore.batch();

//     // Reference to the user's purchases collection
//     final userPurchasesRef =
//         _firestore.collection(_usersCollection).doc(currentUserId).collection(_purchasesCollection);

//     // First, add all items to the items collection
//     final itemRefs = <DocumentReference>[];
//     for (var item in items) {
//       final itemRef = _firestore.collection(_itemsCollection).doc();
//       batch.set(itemRef, item.toJson());
//       itemRefs.add(itemRef);
//     }

//     // Then, add the purchase with references to the items
//     final purchaseRef = userPurchasesRef.doc();
//     final purchaseData = purchase.toFirestore();
//     purchaseData['itemRefs'] = itemRefs;
//     batch.set(purchaseRef, purchaseData);

//     // Commit the batch
//     await batch.commit();
//     return true;
//   }

//   Future<PurchasesModel?> getPurchase(String purchaseId) async {
//     final doc = await _firestore
//         .collection(_usersCollection)
//         .doc(currentUserId)
//         .collection(_purchasesCollection)
//         .doc(purchaseId)
//         .get();
//     if (!doc.exists) return null;
//     return PurchasesModel.fromFirestore(doc);
//   }

//   Stream<List<PurchasesModel>> getPurchases() {
//     return _firestore
//         .collection(_usersCollection)
//         .doc(currentUserId)
//         .collection(_purchasesCollection)
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => PurchasesModel.fromFirestore(doc)).toList());
//   }

//   Future<List<ItemsModel>> getItemsForPurchase(PurchasesModel purchase) async {
//     List<ItemsModel> items = [];

//     for (StockModel stockItem in purchase.items) {
//       // Fetch the full item details from Firestore
//       DocumentSnapshot itemDoc = await _firestore.collection('items').doc(stockItem.item.id).get();

//       if (itemDoc.exists) {
//         items.add(ItemsModel.fromFirestore(itemDoc));
//       } else {
//         // If the item doesn't exist in Firestore, use the data from the stock item
//         items.add(stockItem.item);
//       }
//     }

//     return items;
//   }

//   Future<void> updatePurchase(PurchasesModel purchase) async {
//     await _firestore
//         .collection(_usersCollection)
//         .doc(currentUserId)
//         .collection(_purchasesCollection)
//         .doc(purchase.id)
//         .update(purchase.toFirestore());
//   }

//   Future<void> deletePurchase(String purchaseId) async {
//     final purchaseRef =
//         _firestore.collection(_usersCollection).doc(currentUserId).collection(_purchasesCollection).doc(purchaseId);

//     final purchaseDoc = await purchaseRef.get();
//     if (purchaseDoc.exists) {
//       final purchaseData = purchaseDoc.data() as Map<String, dynamic>;
//       final itemRefs = (purchaseData['itemRefs'] as List<dynamic>).cast<DocumentReference>();

//       final batch = _firestore.batch();

//       // Delete all associated items
//       for (var itemRef in itemRefs) {
//         batch.delete(itemRef);
//       }

//       // Delete the purchase
//       batch.delete(purchaseRef);

//       await batch.commit();
//     }
//   }

//   Future<List<PurchasesModel>> searchPurchases({
//     String? businessName,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     Query query = _firestore.collection(_usersCollection).doc(currentUserId).collection(_purchasesCollection);

//     if (businessName != null && businessName.isNotEmpty) {
//       query = query.where('businessName', isEqualTo: businessName);
//     }

//     if (startDate != null) {
//       query = query.where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
//     }

//     if (endDate != null) {
//       query = query.where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
//     }

//     final querySnapshot = await query.get();
//     return querySnapshot.docs.map((doc) => PurchasesModel.fromFirestore(doc)).toList();
//   }
// }
