import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/app/products/model/recipe_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductsController {
  final NavigationController navigationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProductsController(this.navigationController);

  Future<void> createProduct(String productName, List<RecipeModel> recipe) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      QuerySnapshot existingProducts = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('products')
          .where('productName', isEqualTo: productName)
          .get();

      if (existingProducts.docs.isNotEmpty) {
        throw Exception('A product with this name already exists');
      }

      List<Map<String, dynamic>> recipeData = recipe.map((recipeItem) {
        return {
          'amount': recipeItem.amount,
          'item': {
            'itemName': recipeItem.item.itemName,
            'measurement': recipeItem.item.measurement,
            'vatNumber': recipeItem.item.vatNumber,
          }
        };
      }).toList();

      Map<String, dynamic> productData = {
        'productName': productName,
        'recipe': recipeData,
      };

      await _firestore.collection('users').doc(user.uid).collection('products').add(productData);
      print('Product created successfully: $productName');
    } catch (e) {
      print('Error creating product: $e');
      rethrow;
    }
  }

  Stream<List<ProductsModel>> getAllProducts() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
    return _firestore.collection('users').doc(user.uid).collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductsModel.fromFirestore(doc)).toList();
    });
  }
}
