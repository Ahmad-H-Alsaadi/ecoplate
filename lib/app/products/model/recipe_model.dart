import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_model.freezed.dart';
part 'recipe_model.g.dart';

@freezed
class RecipeModel with _$RecipeModel {
  const RecipeModel._();

  const factory RecipeModel({
    required double amount,
    required ItemsModel item,
  }) = _RecipeModel;

  factory RecipeModel.fromJson(Map<String, dynamic> json) => _$RecipeModelFromJson(json);

  factory RecipeModel.fromFirestore(Map<String, dynamic> data) {
    return RecipeModel(
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      item: ItemsModel.fromJson(data['item'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..['item'] = item.toJson();
  }
}
