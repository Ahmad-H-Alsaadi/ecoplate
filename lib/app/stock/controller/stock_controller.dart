import 'package:ecoplate/core/controllers/navigation_controller.dart';

class StockController {
  final NavigationController navigationController;

  StockController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  // Add other stock-specific methods here
}
