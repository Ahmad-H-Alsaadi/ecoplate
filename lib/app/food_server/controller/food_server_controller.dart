import 'package:ecoplate/core/controllers/navigation_controller.dart';

class FoodServerController {
  final NavigationController navigationController;

  FoodServerController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  // Add other food server-specific methods here
}
