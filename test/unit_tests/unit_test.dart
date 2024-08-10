import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:ecoplate/app/dashboard/controller/dashboard_controller.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/app/detect_food_waste/model/detect_food_waste_model.dart';

class MockNavigationController extends Mock implements NavigationController {}

void main() {
  late DashboardController dashboardController;
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockAuth;
  late MockNavigationController mockNavigationController;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockNavigationController = MockNavigationController();

    final user = MockUser(
      uid: 'test-uid',
      email: 'test@test.com',
    );

    mockAuth = MockFirebaseAuth(signedIn: true, mockUser: user);

    dashboardController = DashboardController(
      mockNavigationController,
      firestore: fakeFirestore,
      auth: mockAuth,
    );
  });

  test('navigateTo calls navigation controller', () {
    dashboardController.navigateTo('/test-route');
    verify(mockNavigationController.navigateTo('/test-route')).called(1);
  });

  group('getFoodWasteStream', () {
    test('returns correct stream', () async {
      await fakeFirestore
          .collection('users')
          .doc('test-uid')
          .collection('food_waste_detections')
          .add({
        'productName': 'Test Product',
        'wastePercentage': 10.0,
        'timestamp': DateTime.now(),
      });

      final stream = dashboardController.getFoodWasteStream();
      expect(stream, emits(isA<List<DetectFoodWasteModel>>()));
    });
  });

  test('navigateToFoodSurvey calls navigation controller', () {
    dashboardController.navigateToFoodSurvey();
    verify(mockNavigationController.navigateTo('/food_survey')).called(1);
  });

  group('getLowStockItemsCount', () {
    test('returns correct count', () async {
      await fakeFirestore
          .collection('users')
          .doc('test-uid')
          .collection('stock')
          .add({
        'amount': 5,
        'item': {'itemName': 'Item 1', 'measurement': 'kg'},
        'expireDate': DateTime.now().add(Duration(days: 30)),
      });
      await fakeFirestore
          .collection('users')
          .doc('test-uid')
          .collection('stock')
          .add({
        'amount': 15,
        'item': {'itemName': 'Item 2', 'measurement': 'kg'},
        'expireDate': DateTime.now().add(Duration(days: 30)),
      });

      final stream = dashboardController.getLowStockItemsCount();
      expect(await stream.first, 1);
    });
  });

  group('getTotalProductsCount', () {
    test('returns correct count', () async {
      await fakeFirestore
          .collection('users')
          .doc('test-uid')
          .collection('products')
          .add({
        'productName': 'Product 1',
        'recipe': [],
      });
      await fakeFirestore
          .collection('users')
          .doc('test-uid')
          .collection('products')
          .add({
        'productName': 'Product 2',
        'recipe': [],
      });

      final stream = dashboardController.getTotalProductsCount();
      expect(await stream.first, 2);
    });
  });
}
