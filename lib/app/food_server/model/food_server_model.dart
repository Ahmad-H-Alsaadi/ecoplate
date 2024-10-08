import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_server_model.freezed.dart';
part 'food_server_model.g.dart';

@freezed
class FoodServerModel with _$FoodServerModel {
  const factory FoodServerModel({
    required List<ProductsModel> products,
    required Map<String, int> selections,
  }) = _FoodServerModel;

  factory FoodServerModel.fromJson(Map<String, dynamic> json) => _$FoodServerModelFromJson(json);
}

@freezed
class FoodServerSelection with _$FoodServerSelection {
  const factory FoodServerSelection({
    required String productId,
    required int quantity,
  }) = _FoodServerSelection;

  factory FoodServerSelection.fromJson(Map<String, dynamic> json) => _$FoodServerSelectionFromJson(json);
}

@freezed
class FoodSurveyModel with _$FoodSurveyModel {
  const factory FoodSurveyModel({
    required String productName,
    required String quantityReceived,
    required String quantityWasted,
    required List<String> wasteReasons,
    required String satisfactionLevel,
    String? otherProduct,
    String? otherWasteReason,
    String? improvementSuggestions,
    required DateTime timestamp,
  }) = _FoodSurveyModel;

  factory FoodSurveyModel.fromJson(Map<String, dynamic> json) => _$FoodSurveyModelFromJson(json);
}
