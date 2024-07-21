import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'recipe_model.freezed.dart';
part 'recipe_model.g.dart';

@freezed
class RecipeModel with _$RecipeModel {
  const RecipeModel._();

  const factory RecipeModel({
    required String productId,
    required ItemsModel item,
    required double amount,
  }) = _RecipeModel;

  factory RecipeModel.fromJson(Map<String, dynamic> json) => _$RecipeModelFromJson(json);

  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel(
      productId: data['productId'] as String,
      item: ItemsModel.fromJson(data['item'] as Map<String, dynamic>),
      amount: (data['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..['item'] = item.toFirestore();
  }
}
