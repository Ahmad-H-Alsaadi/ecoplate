// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockModelImpl _$$StockModelImplFromJson(Map<String, dynamic> json) =>
    _$StockModelImpl(
      id: json['id'] as String,
      item: ItemsModel.fromJson(json['item'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      expireDate: DateTime.parse(json['expireDate'] as String),
    );

Map<String, dynamic> _$$StockModelImplToJson(_$StockModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item': instance.item,
      'amount': instance.amount,
      'expireDate': instance.expireDate.toIso8601String(),
    };
