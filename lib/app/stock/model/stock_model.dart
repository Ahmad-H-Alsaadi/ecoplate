import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'stock_model.freezed.dart';
part 'stock_model.g.dart';

@freezed
class StockModel with _$StockModel {
  const StockModel._();

  const factory StockModel({
    required String id,
    required ItemsModel item,
    required double amount,
    required DateTime expireDate,
  }) = _StockModel;

  factory StockModel.fromJson(Map<String, dynamic> json) => _$StockModelFromJson(json);

  factory StockModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StockModel(
      id: doc.id,
      item: ItemsModel.fromJson(data['item'] as Map<String, dynamic>),
      amount: (data['amount'] as num).toDouble(),
      expireDate: (data['expireDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson()
      ..remove('id')
      ..['item'] = item.toFirestore()
      ..['expireDate'] = Timestamp.fromDate(expireDate);
  }
}
