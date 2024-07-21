import 'package:ecoplate/core/controllers/navigation_controller.dart';

class DashboardController {
  final NavigationController navigationController;

  DashboardController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  // Add other dashboard-specific methods here
}
