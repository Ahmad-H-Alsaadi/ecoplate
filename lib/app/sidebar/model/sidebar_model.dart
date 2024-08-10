import 'package:ecoplate/core/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class SidebarModel {
  final IconData icon;
  final String title;
  final String routeName;

  SidebarModel({
    required this.icon,
    required this.title,
    required this.routeName,
  });
}

class SidebarData {
  static final List<SidebarModel> items = [
    SidebarModel(
      icon: IconConstants.kHome,
      title: 'Home',
      routeName: '/home',
    ),
    SidebarModel(
      icon: IconConstants.kDashboard,
      title: 'Dashboard',
      routeName: '/dashboard',
    ),
    SidebarModel(
      icon: IconConstants.kPurchases,
      title: 'Purchases',
      routeName: '/purchases',
    ),
    SidebarModel(
      icon: IconConstants.kItems,
      title: 'Items',
      routeName: '/items',
    ),
    SidebarModel(
      icon: IconConstants.kProducts,
      title: 'Products',
      routeName: '/products',
    ),
    SidebarModel(
      icon: IconConstants.kFoodServer,
      title: 'Food Server',
      routeName: '/food_server',
    ),
    SidebarModel(
      icon: IconConstants.kStock,
      title: 'Stock',
      routeName: '/stock',
    ),
    SidebarModel(
      icon: IconConstants.kDetectFoodWaste,
      title: 'Detect Food Waste',
      routeName: '/detect_food_waste',
    ),
    SidebarModel(
      icon: IconConstants.kSurvey,
      title: 'Survey',
      routeName: '/food_survey',
    ),
    SidebarModel(
      icon: IconConstants.kLogout,
      title: 'Log out',
      routeName: '/logout',
    ),
  ];
}
