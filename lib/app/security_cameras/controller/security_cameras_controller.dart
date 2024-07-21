import 'package:ecoplate/core/controllers/navigation_controller.dart';

class SecurityCamerasController {
  final NavigationController navigationController;

  SecurityCamerasController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  // Add other security cameras-specific methods here
}
