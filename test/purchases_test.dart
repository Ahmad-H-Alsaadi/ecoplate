import 'package:flutter_test/flutter_test.dart';

class PurchaseItem {
  final String name;
  final double amount;
  final int quantity;

  PurchaseItem({required this.name, required this.amount, required this.quantity});
}

class PurchaseSummary {
  final List<PurchaseItem> items;
  final double totalAmount;
  final String storeName;

  PurchaseSummary({required this.items, required this.totalAmount, required this.storeName});
}

class PurchasesController {
  PurchaseSummary? decodePurchaseData(String qrCode) {
    try {
      // Simulate QR code decoding
      final parts = qrCode.split('|');
      if (parts.length < 3) return null;

      final storeName = parts[0];
      final totalAmount = double.parse(parts[1]);
      final items = parts.sublist(2).map((item) {
        final itemParts = item.split(',');
        return PurchaseItem(
          name: itemParts[0],
          amount: double.parse(itemParts[1]),
          quantity: int.parse(itemParts[2]),
        );
      }).toList();

      return PurchaseSummary(items: items, totalAmount: totalAmount, storeName: storeName);
    } catch (e) {
      return null;
    }
  }

  double calculateTotalWaste(PurchaseSummary summary) {
    return summary.items.map((item) => item.amount * item.quantity).reduce((a, b) => a + b) - summary.totalAmount;
  }
}

void main() {
  group('PurchasesController Tests', () {
    late PurchasesController controller;

    setUp(() {
      controller = PurchasesController();
    });

    test('decodePurchaseData correctly decodes valid QR code', () {
      const qrCode = 'EcoStore|50.00|Apple,1.00,2|Banana,0.50,4|Milk,3.00,1';
      final result = controller.decodePurchaseData(qrCode);

      expect(result, isNotNull);
      expect(result!.storeName, equals('EcoStore'));
      expect(result.totalAmount, equals(50.00));
      expect(result.items.length, equals(3));
      expect(result.items[0].name, equals('Apple'));
      expect(result.items[1].amount, equals(0.50));
      expect(result.items[2].quantity, equals(1));
    });
    double calculateTotalWaste(PurchaseSummary summary) {
      double itemsTotal = summary.items.map((item) => item.amount * item.quantity).reduce((a, b) => a + b);
      return itemsTotal - summary.totalAmount;
    }

    test('calculateTotalWaste computes correct waste amount', () {
      final summary = PurchaseSummary(
        storeName: 'EcoStore',
        totalAmount: 50.00,
        items: [
          PurchaseItem(name: 'Apple', amount: 1.00, quantity: 2),
          PurchaseItem(name: 'Banana', amount: 0.50, quantity: 4),
          PurchaseItem(name: 'Milk', amount: 3.00, quantity: 1),
        ],
      );

      final waste = controller.calculateTotalWaste(summary);
      expect(waste, equals(-43.00));
    });
  });
}
