import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'recipe_model.dart';

part 'products_model.freezed.dart';
part 'products_model.g.dart';

@freezed
class ProductsModel with _$ProductsModel {
  const ProductsModel._();

  const factory ProductsModel({
    required String productName,
    required List<RecipeModel> recipe,
  }) = _ProductsModel;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => _$ProductsModelFromJson(json);

  factory ProductsModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return ProductsModel(
      productName: data['productName'] as String? ?? '',
      recipe: (data['recipe'] as List<dynamic>?)
              ?.map((item) => RecipeModel.fromJson(item as Map<String, dynamic>? ?? {}))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..['recipe'] = recipe.map((e) => e.toJson()).toList();
  }
}
