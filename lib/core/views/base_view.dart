// lib/core/views/base_view.dart

import 'package:ecoplate/app/sidebar/view/sidebar_view.dart';
import 'package:ecoplate/core/components/eco_plate_appbar.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';

class BaseView extends StatelessWidget {
  final Widget body;
  final String title;
  final String? imagePath;
  final NavigationController navigationController;

  const BaseView({
    Key? key,
    required this.body,
    required this.title,
    this.imagePath,
    required this.navigationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: EcoPlateAppbar(
        imagePath: imagePath,
        navigationController: navigationController,
      ),
      drawer: SidebarView(
        onItemTap: (routeName) => navigationController..navigateTo(routeName),
      ),
      body: body,
    );
  }
}
