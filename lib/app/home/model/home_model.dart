import 'package:ecoplate/core/constants/icon_constants.dart';
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
      icon: IconConstants.kDashboard,
      title: "Dashboard",
      route: '/dashboard',
    ),
    HomeModel(
      icon: IconConstants.kDetectFoodWaste,
      title: "Detect Food Waste",
      route: '/detect_food_waste',
    ),
    HomeModel(
      icon: IconConstants.kStock,
      title: "Stock",
      route: '/stock',
    ),
    HomeModel(
      icon: IconConstants.kPurchases,
      title: "Scan Purchases",
      route: '/purchases',
    ),
    HomeModel(
      icon: IconConstants.kFoodServer,
      title: "Food Server",
      route: '/food_server',
    ),
    HomeModel(
      icon: IconConstants.kSurvey,
      title: "Survey",
      route: '/food_survey',
    ),
  ];
}
