import 'package:ecoplate/core/controllers/navigation_controller.dart';

class ItemsController {
  final NavigationController navigationController;

  ItemsController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  // Add other items-specific methods here
}
