import 'package:mockito/mockito.dart';
import 'package:ecoplate/app/dashboard/controller/dashboard_controller.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';

class MockDashboardController extends Mock implements DashboardController {
  final NavigationController navigationController;
  MockDashboardController(this.navigationController);
}
