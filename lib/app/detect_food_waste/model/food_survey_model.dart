import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'food_survey_model.freezed.dart';
part 'food_survey_model.g.dart';

@freezed
class FoodSurveyModel with _$FoodSurveyModel {
  const FoodSurveyModel._();

  const factory FoodSurveyModel({
    required String productName,
    String? otherProduct,
    required String quantityReceived,
    required String quantityWasted,
    required List<String> wasteReasons,
    String? otherWasteReason,
    required String satisfactionLevel,
    String? improvementSuggestions,
    @JsonKey(ignore: true) Timestamp? timestamp,
  }) = _FoodSurveyModel;

  factory FoodSurveyModel.fromJson(Map<String, dynamic> json) => _$FoodSurveyModelFromJson(json);

  Map<String, dynamic> toFirestore() {
    return toJson()..['timestamp'] = timestamp ?? FieldValue.serverTimestamp();
  }
}
