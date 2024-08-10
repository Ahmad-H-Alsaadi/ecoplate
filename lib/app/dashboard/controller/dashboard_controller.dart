import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/detect_food_waste/model/detect_food_waste_model.dart';
import 'package:ecoplate/app/detect_food_waste/model/food_survey_model.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardController {
  final NavigationController navigationController;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DashboardController(
    this.navigationController, {
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  Stream<List<DetectFoodWasteModel>> getFoodWasteStream() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('food_waste_detections')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DetectFoodWasteModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<StockModel>> getStockStream() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('stock')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => StockModel.fromFirestore(doc)).toList());
  }

  Stream<double> getAverageFoodWaste() {
    return getFoodWasteStream().map((foodWasteList) {
      if (foodWasteList.isEmpty) return 0.0;
      double sum =
          foodWasteList.fold(0, (sum, item) => sum + item.wastePercentage);
      return sum / foodWasteList.length;
    });
  }

  Stream<List<ProductsModel>> getProductsStream() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductsModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<FoodSurveyModel>> getFoodSurveyStream() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('surveys')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodSurveyModel.fromJson(doc.data()))
            .toList());
  }

  void navigateToFoodSurvey() {
    navigationController.navigateTo('/food_survey');
  }

  // New methods

  Stream<int> getLowStockItemsCount() {
    return getStockStream().map((stockList) {
      return stockList.where((item) => item.amount < 10).length;
    });
  }

  Stream<int> getTotalProductsCount() {
    return getProductsStream().map((productsList) => productsList.length);
  }
}
