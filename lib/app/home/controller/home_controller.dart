// home_controller.dart
import 'package:ecoplate/app/dashboard/view/dashboard_view.dart';
import 'package:ecoplate/app/food_server/view/food_server_view.dart';
import 'package:ecoplate/app/home/model/home_model.dart';
import 'package:ecoplate/app/items/view/items_view.dart';
import 'package:ecoplate/app/products/view/products_view.dart';
import 'package:ecoplate/app/purcheses/view/purcheses_view.dart';
import 'package:ecoplate/app/security_cameras/view/detect_food_waste_view.dart';
import 'package:ecoplate/app/stock/view/stock_view.dart';
import 'package:ecoplate/app/wallet/view/wallet_view.dart';
import 'package:flutter/material.dart';

class HomeController {
  void handleNavigation(BuildContext context, String routeName) {
    Navigator.pop(context); // Close the drawer
    switch (routeName) {
      case '/home':
        // Already on home, do nothing or refresh
        break;
      case '/dashboard':
        _navigateTo(context, const DashboardView());
        break;
      case '/purchases':
        _navigateTo(context, const PurchesesView());
        break;
      case '/items':
        _navigateTo(context, const ItemsView());
        break;
      case '/products':
        _navigateTo(context, const ProductsView());
        break;
      case '/food_server':
        _navigateTo(context, const FoodServerView());
        break;
      case '/wallet':
        _navigateTo(context, const WalletView());
        break;
      case '/stock':
        _navigateTo(context, const StockView());
        break;
      case '/detect_food_waste':
        _navigateTo(context, const DetectFoodWasteView());
        break;
    }
  }

  void _navigateTo(BuildContext context, Widget view) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => view),
    );
  }

  List<HomeModel> getGridItems() {
    return HomeData.items;
  }
}
