import 'package:ecoplate/app/home/controller/home_controller.dart';
import 'package:ecoplate/core/components/icon_button_with_title.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final NavigationController navigationController;

  const HomeView({Key? key, required this.navigationController}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController(widget.navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Home',
      imagePath: Assets.kHome,
      navigationController: controller.navigationController,
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
            children: controller
                .getGridItems()
                .map(
                  (item) => IconButtonWithTitle(
                    icon: item.icon,
                    title: item.title,
                    onTap: () => controller.navigateTo(item.route),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
