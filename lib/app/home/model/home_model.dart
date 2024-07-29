import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class HomeModel {
  final IconData icon;
  final String title;
  final String route;
  final Color color;

  HomeModel({
    required this.icon,
    required this.title,
    required this.route,
    this.color = ColorConstants.kPrimaryColor,
  });
}

class HomeData {
  static List<HomeModel> items = [
    HomeModel(
      icon: IconConstants.kDashboard,
      title: "Dashboard",
      route: '/dashboard',
      color: ColorConstants.kAccentColor,
    ),
    HomeModel(
      icon: IconConstants.kDetectFoodWaste,
      title: "Detect Food Waste",
      route: '/detect_food_waste',
      color: ColorConstants.kErrorColor,
    ),
    HomeModel(
      icon: IconConstants.kStock,
      title: "Manage Stock",
      route: '/stock',
      color: ColorConstants.kPrimaryColor,
    ),
    HomeModel(
      icon: IconConstants.kPurchases,
      title: "Scan Purchases",
      route: '/purchases',
      color: ColorConstants.kAccentColor,
    ),
    HomeModel(
      icon: IconConstants.kFoodServer,
      title: "Food Server",
      route: '/food_server',
      color: ColorConstants.kPrimaryColor,
    ),
    HomeModel(
      icon: IconConstants.kWallet,
      title: "Wallet",
      route: '/wallet',
      color: ColorConstants.kAccentColor,
    ),
  ];
}
