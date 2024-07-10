import 'package:ecoplate/app/home/controller/home_controller.dart';
import 'package:ecoplate/app/sidebar/view/sidebar_view.dart';
import 'package:ecoplate/core/components/eco_plate_appbar.dart';
import 'package:ecoplate/core/components/icon_button_with_title.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const EcoPlateAppbar(),
      drawer: SidebarView(
        onItemTap: (routeName) => _controller.handleNavigation(context, routeName),
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
            children: _controller
                .getGridItems()
                .map(
                  (item) => IconButtonWithTitle(
                    icon: item.icon,
                    title: item.title,
                    onTap: () => _controller.handleNavigation(context, item.route),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
