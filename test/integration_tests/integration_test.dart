import 'package:ecoplate/app/detect_food_waste/model/detect_food_waste_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ecoplate/app/dashboard/view/dashboard_view.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/app/dashboard/controller/dashboard_controller.dart';

class MockNavigationController extends Mock implements NavigationController {}

class MockDashboardController extends Mock implements DashboardController {
  final NavigationController navigationController;
  MockDashboardController(this.navigationController);

  @override
  Stream<double> getAverageFoodWaste() => Stream.value(10.0);
  @override
  Stream<int> getLowStockItemsCount() => Stream.value(5);
  @override
  Stream<int> getTotalProductsCount() => Stream.value(20);
  @override
  Stream<List<DetectFoodWasteModel>> getFoodWasteStream() => Stream.value([]);
  @override
  Stream<List<StockModel>> getStockStream() => Stream.value([]);
}

void main() {
  late MockNavigationController mockNavigationController;
  late MockDashboardController mockDashboardController;

  setUp(() {
    mockNavigationController = MockNavigationController();
    mockDashboardController = MockDashboardController(mockNavigationController);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: DashboardView(
        navigationController: mockNavigationController,
        controller: mockDashboardController,
      ),
    );
  }

  testWidgets('DashboardView displays all expected widgets',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Average Food Waste'), findsOneWidget);
    expect(find.text('Low Stock Items'), findsNWidgets(2));
    expect(find.text('Total Products'), findsOneWidget);
    expect(find.text('Food Waste Trend'), findsOneWidget);
    expect(find.text('Stock Overview'), findsOneWidget);
    expect(find.text('Recent Food Waste'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Add Food Waste'), findsOneWidget);
    expect(find.text('Add Purchase'), findsOneWidget);
    expect(find.text('Update Stock'), findsOneWidget);
    expect(find.text('Food Survey'), findsOneWidget);
  });

  testWidgets('Quick action buttons call correct navigation methods',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Add Food Waste'));
    await tester.tap(find.text('Add Food Waste'));
    await tester.pumpAndSettle();
    verify(mockDashboardController.navigateTo('/camera')).called(1);

    await tester.ensureVisible(find.text('Add Purchase'));
    await tester.tap(find.text('Add Purchase'));
    await tester.pumpAndSettle();
    verify(mockDashboardController.navigateTo('/purchases')).called(1);

    await tester.ensureVisible(find.text('Update Stock'));
    await tester.tap(find.text('Update Stock'));
    await tester.pumpAndSettle();
    verify(mockDashboardController.navigateTo('/stock')).called(1);

    await tester.ensureVisible(find.text('Food Survey'));
    await tester.tap(find.text('Food Survey'));
    await tester.pumpAndSettle();
    verify(mockDashboardController.navigateToFoodSurvey()).called(1);
  });
}
