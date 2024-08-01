import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/detect_food_waste/model/food_survey_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';

class FoodSurveyController {
  final NavigationController navigationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FoodSurveyModel survey = const FoodSurveyModel(
    productName: '',
    quantityReceived: '',
    quantityWasted: '',
    wasteReasons: [],
    satisfactionLevel: '',
  );

  FoodSurveyController(this.navigationController);

  Stream<List<ProductsModel>> get productsStream => getAllProducts();

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

  void setProduct(String name, String? other) {
    survey = survey.copyWith(productName: name, otherProduct: other?.isNotEmpty == true ? other : null);
  }

  void setQuantityReceived(String quantity) {
    survey = survey.copyWith(quantityReceived: quantity);
  }

  void setQuantityWasted(String quantity) {
    survey = survey.copyWith(quantityWasted: quantity);
  }

  void setWasteReasons(List<String> reasons, String? other) {
    survey = survey.copyWith(wasteReasons: reasons, otherWasteReason: other?.isNotEmpty == true ? other : null);
  }

  void setSatisfactionLevel(String level) {
    survey = survey.copyWith(satisfactionLevel: level);
  }

  void setImprovementSuggestions(String suggestions) {
    survey = survey.copyWith(improvementSuggestions: suggestions.isNotEmpty ? suggestions : null);
  }

  Future<void> submitSurvey(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in')),
      );
      return;
    }
    if (survey.productName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product')),
      );
      return;
    }
    try {
      await _firestore.collection('users').doc(user.uid).collection('surveys').add(survey.toFirestore());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey submitted successfully')),
      );
      navigationController.navigateTo('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting survey: $e')),
      );
    }
  }
}
