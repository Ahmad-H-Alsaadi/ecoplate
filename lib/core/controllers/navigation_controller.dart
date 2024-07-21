// lib/core/controllers/navigation_controller.dart

import 'package:ecoplate/app/dashboard/view/dashboard_view.dart';
import 'package:ecoplate/app/food_server/view/food_server_view.dart';
import 'package:ecoplate/app/home/view/home_view.dart';
import 'package:ecoplate/app/items/view/items_view.dart';
import 'package:ecoplate/app/products/view/products_view.dart';
import 'package:ecoplate/app/purchases/view/purchases_view.dart';
import 'package:ecoplate/app/purchases/view/qr_code_view.dart';
import 'package:ecoplate/app/security_cameras/view/camera_view.dart';
import 'package:ecoplate/app/security_cameras/view/detect_food_waste_view.dart';
import 'package:ecoplate/app/stock/view/stock_view.dart';
import 'package:ecoplate/app/wallet/view/wallet_view.dart';
import 'package:flutter/material.dart';

class NavigationController {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationController({required this.navigatorKey});

  void navigateTo(String routeName, {Map<String, dynamic>? arguments}) {
    switch (routeName) {
      case '/home':
        _navigateTo(HomeView(navigationController: this));
        break;
      case '/dashboard':
        _navigateTo(DashboardView(navigationController: this));
        break;
      case '/purchases':
        _navigateTo(PurchasesView(
          navigationController: this,
          decodedData: arguments ?? {},
        ));
        break;
      case '/items':
        _navigateTo(ItemsView(navigationController: this));
        break;
      case '/products':
        _navigateTo(ProductsView(navigationController: this));
        break;
      case '/food_server':
        _navigateTo(FoodServerView(navigationController: this));
        break;
      case '/wallet':
        _navigateTo(WalletView(navigationController: this));
        break;
      case '/stock':
        _navigateTo(StockView(navigationController: this));
        break;
      case '/qr_code_scanner':
        _navigateTo(QRCodeView(navigationController: this));
        break;
      case '/camera':
        _navigateTo(CameraView());
        break;
      case '/detect_food_waste':
        _navigateTo(DetectFoodWasteView(navigationController: this));
        break;
      default:
        print('Unknown route: $routeName');
    }
  }

  void _navigateTo(Widget view) {
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => view),
    );
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
