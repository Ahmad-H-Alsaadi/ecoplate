import 'package:ecoplate/core/controllers/navigation_controller.dart';

class ProductsController {
  final NavigationController navigationController;

  ProductsController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  // Add other products-specific methods here
}
