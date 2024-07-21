import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipe_model.dart';

part 'products_model.freezed.dart';
part 'products_model.g.dart';

@freezed
class ProductsModel with _$ProductsModel {
  const ProductsModel._();

  const factory ProductsModel({
    required String productId,
    required String productName,
    required List<RecipeModel> recipe,
  }) = _ProductsModel;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => _$ProductsModelFromJson(json);

  factory ProductsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductsModel(
      productId: doc.id,
      productName: data['productName'] as String,
      recipe: (data['recipe'] as List<dynamic>).map((e) => RecipeModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()
      ..remove('productId')
      ..['recipe'] = recipe.map((e) => e.toFirestore()).toList();
  }
}
