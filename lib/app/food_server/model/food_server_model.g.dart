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
