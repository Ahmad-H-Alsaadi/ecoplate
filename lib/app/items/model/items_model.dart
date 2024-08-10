import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'items_model.freezed.dart';
part 'items_model.g.dart';

@freezed
class ItemsModel with _$ItemsModel {
  const ItemsModel._();

  const factory ItemsModel({
    String? id,
    required String itemName,
    required String measurement,
    @Default('') String vatNumber,
  }) = _ItemsModel;

  factory ItemsModel.fromJson(Map<String, dynamic> json) => _$ItemsModelFromJson(json);

  factory ItemsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ItemsModel(
      id: doc.id,
      itemName: data['itemName'] as String? ?? '',
      measurement: data['measurement'] as String? ?? '',
      vatNumber: data['vatNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..removeWhere((key, value) => value == null);
  }
}
