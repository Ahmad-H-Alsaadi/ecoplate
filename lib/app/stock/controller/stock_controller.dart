import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StockController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<StockModel>> getStockStream() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('stock')
        .orderBy('expireDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => StockModel.fromFirestore(doc)).toList();
    });
  }
}
