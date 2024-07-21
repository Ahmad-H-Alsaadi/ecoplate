// // lib/app/seller/service/seller_service.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecoplate/app/purchases/model/seller_model.dart';

// class SellerService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _sellersCollection = 'sellers';

//   Future<SellerModel> getOrCreateSeller(String sellerName, String vatNumber) async {
//     // First, try to find an existing seller with the given VAT number
//     final querySnapshot =
//         await _firestore.collection(_sellersCollection).where('vatNumber', isEqualTo: vatNumber).limit(1).get();

//     if (querySnapshot.docs.isNotEmpty) {
//       // Seller exists, return it
//       return SellerModel.fromFirestore(querySnapshot.docs.first);
//     } else {
//       // Seller doesn't exist, create a new one
//       final newSeller = SellerModel(
//         id: '',
//         sellerName: sellerName,
//         vatNumber: vatNumber,
//       );

//       final docRef = await _firestore.collection(_sellersCollection).add(newSeller.toFirestore());
//       return newSeller.copyWith(id: docRef.id);
//     }
//   }

//   Future<SellerModel?> getSellerById(String id) async {
//     final docSnapshot = await _firestore.collection(_sellersCollection).doc(id).get();
//     if (docSnapshot.exists) {
//       return SellerModel.fromFirestore(docSnapshot);
//     }
//     return null;
//   }

//   Future<List<SellerModel>> getAllSellers() async {
//     final querySnapshot = await _firestore.collection(_sellersCollection).get();
//     return querySnapshot.docs.map((doc) => SellerModel.fromFirestore(doc)).toList();
//   }

//   Future<void> updateSeller(SellerModel seller) async {
//     await _firestore.collection(_sellersCollection).doc(seller.id).update(seller.toFirestore());
//   }

//   Future<void> deleteSeller(String id) async {
//     await _firestore.collection(_sellersCollection).doc(id).delete();
//   }
// }
