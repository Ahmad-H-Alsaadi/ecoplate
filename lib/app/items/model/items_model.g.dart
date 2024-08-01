// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemsModelImpl _$$ItemsModelImplFromJson(Map<String, dynamic> json) =>
    _$ItemsModelImpl(
      id: json['id'] as String?,
      itemName: json['itemName'] as String,
      measurement: json['measurement'] as String,
      vatNumber: json['vatNumber'] as String? ?? '',
    );

Map<String, dynamic> _$$ItemsModelImplToJson(_$ItemsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemName': instance.itemName,
      'measurement': instance.measurement,
      'vatNumber': instance.vatNumber,
    };
