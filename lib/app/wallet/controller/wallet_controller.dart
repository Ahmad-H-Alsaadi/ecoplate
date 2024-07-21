import 'package:ecoplate/core/controllers/navigation_controller.dart';

class WalletController {
  final NavigationController navigationController;

  WalletController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  // Add other wallet-specific methods here
}
