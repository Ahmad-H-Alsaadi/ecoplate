// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_server_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodServerModelImpl _$$FoodServerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FoodServerModelImpl(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      selections: Map<String, int>.from(json['selections'] as Map),
    );

Map<String, dynamic> _$$FoodServerModelImplToJson(
        _$FoodServerModelImpl instance) =>
    <String, dynamic>{
      'products': instance.products,
      'selections': instance.selections,
    };

_$FoodServerSelectionImpl _$$FoodServerSelectionImplFromJson(
        Map<String, dynamic> json) =>
    _$FoodServerSelectionImpl(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$FoodServerSelectionImplToJson(
        _$FoodServerSelectionImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
    };

_$FoodSurveyModelImpl _$$FoodSurveyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FoodSurveyModelImpl(
      productName: json['productName'] as String,
      quantityReceived: json['quantityReceived'] as String,
      quantityWasted: json['quantityWasted'] as String,
      wasteReasons: (json['wasteReasons'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      satisfactionLevel: json['satisfactionLevel'] as String,
      otherProduct: json['otherProduct'] as String?,
      otherWasteReason: json['otherWasteReason'] as String?,
      improvementSuggestions: json['improvementSuggestions'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$FoodSurveyModelImplToJson(
        _$FoodSurveyModelImpl instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'quantityReceived': instance.quantityReceived,
      'quantityWasted': instance.quantityWasted,
      'wasteReasons': instance.wasteReasons,
      'satisfactionLevel': instance.satisfactionLevel,
      'otherProduct': instance.otherProduct,
      'otherWasteReason': instance.otherWasteReason,
      'improvementSuggestions': instance.improvementSuggestions,
      'timestamp': instance.timestamp.toIso8601String(),
    };
