// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecoplate/app/stock/model/stock_model.dart';

// class StockService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _stockCollection = 'stock';

//   // Add a new stock item
//   Future<void> addToStock(StockModel stock) async {
//     await _firestore.collection(_stockCollection).add(stock.toFirestore());
//   }

//   // Get all stock items
//   Stream<List<StockModel>> getAllStock() {
//     return _firestore
//         .collection(_stockCollection)
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => StockModel.fromFirestore(doc)).toList());
//   }

//   // Get stock items that are expiring soon (within the next 7 days)
//   Stream<List<StockModel>> getExpiringSoonStock() {
//     final sevenDaysFromNow = DateTime.now().add(Duration(days: 7));
//     return _firestore
//         .collection(_stockCollection)
//         .where('expireDate', isLessThanOrEqualTo: sevenDaysFromNow)
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => StockModel.fromFirestore(doc)).toList());
//   }

//   // Update a stock item
//   Future<void> updateStock(StockModel stock) async {
//     await _firestore.collection(_stockCollection).doc(stock.id).update(stock.toFirestore());
//   }

//   // Delete a stock item
//   Future<void> deleteStock(String stockId) async {
//     await _firestore.collection(_stockCollection).doc(stockId).delete();
//   }

//   // Get stock by item ID
//   Future<List<StockModel>> getStockByItemId(String itemId) async {
//     final querySnapshot = await _firestore.collection(_stockCollection).where('item.id', isEqualTo: itemId).get();
//     return querySnapshot.docs.map((doc) => StockModel.fromFirestore(doc)).toList();
//   }

//   // Reduce stock amount
//   Future<void> reduceStockAmount(String stockId, double amountToReduce) async {
//     final docRef = _firestore.collection(_stockCollection).doc(stockId);
//     return _firestore.runTransaction((transaction) async {
//       final docSnapshot = await transaction.get(docRef);
//       if (!docSnapshot.exists) {
//         throw Exception("Stock item does not exist!");
//       }
//       final currentStock = StockModel.fromFirestore(docSnapshot);
//       if (currentStock.amount < amountToReduce) {
//         throw Exception("Not enough stock!");
//       }
//       final newAmount = currentStock.amount - amountToReduce;
//       transaction.update(docRef, {'amount': newAmount});
//     });
//   }
// }
