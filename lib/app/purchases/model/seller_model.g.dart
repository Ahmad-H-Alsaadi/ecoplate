// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerModelImpl _$$SellerModelImplFromJson(Map<String, dynamic> json) =>
    _$SellerModelImpl(
      id: json['id'] as String,
      sellerName: json['sellerName'] as String,
      vatNumber: json['vatNumber'] as String,
    );

Map<String, dynamic> _$$SellerModelImplToJson(_$SellerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sellerName': instance.sellerName,
      'vatNumber': instance.vatNumber,
    };
