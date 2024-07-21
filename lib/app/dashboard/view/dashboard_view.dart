import 'package:ecoplate/app/dashboard/controller/dashboard_controller.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final NavigationController navigationController;
  late final DashboardController controller;

  DashboardView({Key? key, required this.navigationController}) : super(key: key) {
    controller = DashboardController(navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Dashboard',
      imagePath: Assets.kDashBoard, // Assuming you have a dashboard icon
      navigationController: navigationController,
      body: const Center(
        child: Text("Dashboard"),
      ),
    );
  }
}
