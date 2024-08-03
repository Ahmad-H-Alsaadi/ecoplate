import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/detect_food_waste/model/detect_food_waste_model.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CameraController {
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? image;
  String detectionResult = '';
  bool isLoading = false;
  List<Map<String, dynamic>> boxes = [];
  Stream<List<ProductsModel>> productsStream = const Stream.empty();

  Future<void> openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      image = File(photo.path);
      await sendImageToServer();
    }
  }

  Future<void> openGallery() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      image = File(selectedImage.path);
      await sendImageToServer();
    }
  }

  Future<void> sendImageToServer() async {
    if (image == null) return;
    isLoading = true;
    detectionResult = '';
    boxes = [];
    try {
      final bytes = await image!.readAsBytes();
      final base64Image = base64Encode(bytes);
      print("Image size: ${bytes.length} bytes");
      final response = await http.post(
        Uri.parse('http://192.168.37.36:5000/detect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print("Raw server response: $result");
        detectionResult = 'Food Waste: ${result['waste_percentage'].toStringAsFixed(2)}%';
        boxes = List<Map<String, dynamic>>.from(result['detections']);
        print("Boxes: $boxes");
      } else {
        print("Server error: ${response.statusCode} - ${response.body}");
        detectionResult = 'Server Error: ${response.body}';
      }
    } catch (e) {
      print("Error sending image to server: $e");
      detectionResult = 'Error: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }

  Future<ui.Image> getImage(File file) async {
    final bytes = await file.readAsBytes();
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      print("Image decoded: ${img.width} x ${img.height}");
      completer.complete(img);
    });
    return completer.future;
  }

  void loadProducts() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    productsStream = _firestore.collection('users').doc(user.uid).collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductsModel.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> saveProductWaste(ProductsModel product, double wastePercentage) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    try {
      final detectFoodWaste = DetectFoodWasteModel(
        productName: product.productName,
        wastePercentage: wastePercentage,
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('food_waste_detections')
          .add(detectFoodWaste.toFirestore());
    } catch (e) {
      print('Error saving to Firestore: $e');
      throw Exception('Failed to save product waste');
    }
  }

  Future<void> saveAndReduceProductWaste(ProductsModel product, double wastePercentage) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    try {
      // Save the food waste detection
      final detectFoodWaste = DetectFoodWasteModel(
        productName: product.productName,
        wastePercentage: wastePercentage,
        timestamp: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('food_waste_detections')
          .add(detectFoodWaste.toFirestore());

      // Query for the product
      QuerySnapshot productQuery = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('products')
          .where('productName', isEqualTo: product.productName)
          .limit(1)
          .get();

      if (productQuery.docs.isEmpty) {
        throw Exception('Product not found in database');
      }

      DocumentSnapshot productDoc = productQuery.docs.first;

      List<dynamic> currentRecipe = (productDoc.data() as Map<String, dynamic>)['recipe'] ?? [];

      List<Map<String, dynamic>> updatedRecipe = currentRecipe.map((recipeItem) {
        Map<String, dynamic> typedRecipeItem = Map<String, dynamic>.from(recipeItem);
        double currentAmount = typedRecipeItem['amount'] ?? 0.0;
        double reducedAmount = currentAmount * (1 - wastePercentage / 100);
        return {
          ...typedRecipeItem,
          'amount': reducedAmount,
        };
      }).toList();

      await _firestore.collection('users').doc(user.uid).collection('products').doc(productDoc.id).update({
        'recipe': updatedRecipe,
      });
    } catch (e) {
      print('Error saving and reducing product waste: $e');
      if (e is FirebaseException) {
        throw Exception('Firebase error: ${e.code} - ${e.message}');
      } else {
        throw Exception('Failed to save and reduce product waste: ${e.toString()}');
      }
    }
  }
}
