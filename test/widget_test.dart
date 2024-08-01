import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class PurchaseItem {
  final String name;
  final double price;
  final int quantity;

  PurchaseItem({required this.name, required this.price, required this.quantity});
}

class PurchaseSummary {
  final List<PurchaseItem> items;
  final double totalAmount;
  final String storeName;

  PurchaseSummary({required this.items, required this.totalAmount, required this.storeName});
}

class PurchaseSummaryWidget extends StatelessWidget {
  final PurchaseSummary summary;

  const PurchaseSummaryWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Purchase Summary')),
        body: ListView(
          children: [
            ListTile(title: Text('Store: ${summary.storeName}')),
            ListTile(title: Text('Total: \$${summary.totalAmount.toStringAsFixed(2)}')),
            ...summary.items.map((item) => ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                  trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                )),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('PurchaseSummaryWidget displays correct information', (WidgetTester tester) async {
    final summary = PurchaseSummary(
      storeName: 'EcoStore',
      totalAmount: 50.00,
      items: [
        PurchaseItem(name: 'Apple', price: 1.00, quantity: 2),
        PurchaseItem(name: 'Banana', price: 0.50, quantity: 4),
        PurchaseItem(name: 'Milk', price: 3.00, quantity: 1),
      ],
    );

    await tester.pumpWidget(PurchaseSummaryWidget(summary: summary));

    expect(find.text('Purchase Summary'), findsOneWidget);
    expect(find.text('Store: EcoStore'), findsOneWidget);
    expect(find.text('Total: \$50.00'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('2 x \$1.00'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);
    expect(find.text('4 x \$0.50'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('1 x \$3.00'), findsOneWidget);
    expect(find.text('\$3.00'), findsOneWidget);

    // Check for the presence of $2.00 twice (for Apple and Banana)
    expect(find.text('\$2.00'), findsNWidgets(2));
  });
}
