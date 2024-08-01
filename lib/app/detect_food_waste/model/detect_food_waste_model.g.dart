// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detect_food_waste_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DetectFoodWasteModelImpl _$$DetectFoodWasteModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DetectFoodWasteModelImpl(
      productName: json['productName'] as String,
      wastePercentage: (json['wastePercentage'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$DetectFoodWasteModelImplToJson(
        _$DetectFoodWasteModelImpl instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'wastePercentage': instance.wastePercentage,
      'timestamp': instance.timestamp.toIso8601String(),
    };
