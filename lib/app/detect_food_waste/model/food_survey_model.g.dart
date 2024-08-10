// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_survey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodSurveyModelImpl _$$FoodSurveyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FoodSurveyModelImpl(
      productName: json['productName'] as String,
      otherProduct: json['otherProduct'] as String?,
      quantityReceived: json['quantityReceived'] as String,
      quantityWasted: json['quantityWasted'] as String,
      wasteReasons: (json['wasteReasons'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      otherWasteReason: json['otherWasteReason'] as String?,
      satisfactionLevel: json['satisfactionLevel'] as String,
      improvementSuggestions: json['improvementSuggestions'] as String?,
    );

Map<String, dynamic> _$$FoodSurveyModelImplToJson(
        _$FoodSurveyModelImpl instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'otherProduct': instance.otherProduct,
      'quantityReceived': instance.quantityReceived,
      'quantityWasted': instance.quantityWasted,
      'wasteReasons': instance.wasteReasons,
      'otherWasteReason': instance.otherWasteReason,
      'satisfactionLevel': instance.satisfactionLevel,
      'improvementSuggestions': instance.improvementSuggestions,
    };
