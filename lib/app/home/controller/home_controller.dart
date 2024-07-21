import 'package:ecoplate/app/home/model/home_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';

class HomeController {
  final NavigationController navigationController;

  HomeController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  List<HomeModel> getGridItems() {
    return HomeData.items;
  }
}
