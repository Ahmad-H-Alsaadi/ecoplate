import 'package:ecoplate/app/food_server/controller/food_server_controller.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class FoodServerView extends StatelessWidget {
  final NavigationController navigationController;
  late final FoodServerController controller;

  FoodServerView({Key? key, required this.navigationController}) : super(key: key) {
    controller = FoodServerController(navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Food Server',
      imagePath: Assets.kFoodServer, // Assuming you have a food server icon
      navigationController: navigationController,
      body: Center(
        child: Text("Food Server"),
      ),
    );
  }
}
