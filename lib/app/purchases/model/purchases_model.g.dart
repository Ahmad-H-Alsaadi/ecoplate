// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchases_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchasesModelImpl _$$PurchasesModelImplFromJson(Map<String, dynamic> json) =>
    _$PurchasesModelImpl(
      id: json['id'] as String,
      sellerName: json['sellerName'] as String,
      vatNumber: json['vatNumber'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      vatAmount: (json['vatAmount'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PurchasesModelImplToJson(
        _$PurchasesModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sellerName': instance.sellerName,
      'vatNumber': instance.vatNumber,
      'dateTime': instance.dateTime.toIso8601String(),
      'totalAmount': instance.totalAmount,
      'vatAmount': instance.vatAmount,
      'items': instance.items,
    };
