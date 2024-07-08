import 'package:ecoplate/app/dashboard/view/dashboard_view.dart';
import 'package:ecoplate/app/purcheses/view/purcheses_view.dart';
import 'package:ecoplate/app/sidebar/view/sidebar_view.dart';
import 'package:ecoplate/app/stock/view/stock_view.dart';
import 'package:ecoplate/core/components/eco_plate_appbar.dart';
import 'package:ecoplate/core/components/icon_button_with_title.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void _handleNavigation(String routeName) {
    Navigator.pop(context); // Close the drawer
    switch (routeName) {
      case '/home':
        // Already on home, do nothing or refresh
        break;
      case '/dashboard':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardView()),
        );
        break;
      case '/purchases':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PurchesesView()),
        );
        break;
      case '/stock':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StockView()),
        );
        break;
      // Add other routes as needed
    }
  }

  void _handleLogout() {
    // Implement your logout logic here
    print('Logging out...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const EcoPlateAppbar(),
      drawer: SidebarView(
        onItemTap: _handleNavigation,
        onLogout: _handleLogout,
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.0,
            children: <Widget>[
              IconButtonWithTitle(
                icon: Icons.dashboard,
                title: "Dashboard",
                onTap: () => _handleNavigation('/dashboard'),
              ),
              IconButtonWithTitle(
                icon: Icons.no_food,
                title: "Detect Food Waste",
                onTap: () {
                  // Navigate to DetectFoodWasteView
                },
              ),
              IconButtonWithTitle(
                icon: Icons.store,
                title: "Stock",
                onTap: () => _handleNavigation('/stock'),
              ),
              IconButtonWithTitle(
                icon: Icons.qr_code_2,
                title: "Scan Purchases",
                onTap: () => _handleNavigation('/purchases'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
