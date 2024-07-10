// home_model.dart
import 'package:flutter/material.dart';

class HomeModel {
  final IconData icon;
  final String title;
  final String route;

  HomeModel({
    required this.icon,
    required this.title,
    required this.route,
  });
}

class HomeData {
  static List<HomeModel> items = [
    HomeModel(
      icon: Icons.dashboard,
      title: "Dashboard",
      route: '/dashboard',
    ),
    HomeModel(
      icon: Icons.no_food,
      title: "Detect Food Waste",
      route: '/detect_food_waste',
    ),
    HomeModel(
      icon: Icons.store,
      title: "Stock",
      route: '/stock',
    ),
    HomeModel(
      icon: Icons.qr_code_2,
      title: "Scan Purchases",
      route: '/purchases',
    ),
  ];
}
