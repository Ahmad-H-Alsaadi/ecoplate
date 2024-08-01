import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'detect_food_waste_model.freezed.dart';
part 'detect_food_waste_model.g.dart';

@freezed
class DetectFoodWasteModel with _$DetectFoodWasteModel {
  const DetectFoodWasteModel._();

  const factory DetectFoodWasteModel({
    required String productName,
    required double wastePercentage,
    required DateTime timestamp,
  }) = _DetectFoodWasteModel;

  factory DetectFoodWasteModel.fromJson(Map<String, dynamic> json) => _$DetectFoodWasteModelFromJson(json);

  factory DetectFoodWasteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return DetectFoodWasteModel(
      productName: data['productName'] as String? ?? '',
      wastePercentage: (data['wastePercentage'] as num?)?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..['timestamp'] = Timestamp.fromDate(timestamp);
  }
}
