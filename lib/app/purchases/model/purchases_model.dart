import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchases_model.freezed.dart';
part 'purchases_model.g.dart';

@freezed
class PurchasesModel with _$PurchasesModel {
  const PurchasesModel._();

  const factory PurchasesModel({
    required String id,
    required String sellerName,
    required String vatNumber,
    required DateTime dateTime,
    required double totalAmount,
    required double vatAmount,
    required List<StockModel> items,
  }) = _PurchasesModel;

  factory PurchasesModel.fromJson(Map<String, dynamic> json) => _$PurchasesModelFromJson(json);

  factory PurchasesModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PurchasesModel(
      id: doc.id,
      sellerName: data['sellerName'] as String? ?? '',
      vatNumber: data['vatNumber'] as String? ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      vatAmount: (data['vatAmount'] as num?)?.toDouble() ?? 0.0,
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => StockModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()
      ..remove('id')
      ..['dateTime'] = Timestamp.fromDate(dateTime)
      ..['items'] = items.map((item) => item.toFirestore()).toList();
  }
}
