// lib/app/seller/model/seller_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'seller_model.freezed.dart';
part 'seller_model.g.dart';

@freezed
class SellerModel with _$SellerModel {
  const SellerModel._();

  const factory SellerModel({
    required String id,
    required String sellerName,
    required String vatNumber,
  }) = _SellerModel;

  factory SellerModel.fromJson(Map<String, dynamic> json) => _$SellerModelFromJson(json);

  factory SellerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SellerModel(
      id: doc.id,
      sellerName: data['sellerName'] as String,
      vatNumber: data['vatNumber'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()..remove('id');
  }
}
