import 'package:ecoplate/app/home/controller/home_controller.dart';
import 'package:ecoplate/app/home/model/home_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: Insets.largePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              SizedBox(height: Sizes.largeSize),
              _buildGridView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return StreamBuilder<String>(
      stream: controller.getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
        }
        String userName = snapshot.data ?? 'User';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome,', style: TextStyles.heading2),
            Text(userName, style: TextStyles.heading1.copyWith(color: ColorConstants.kPrimaryColor)),
            SizedBox(height: Sizes.mediumSize),
            Text('What would you like to do today?', style: TextStyles.bodyText1),
          ],
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: Sizes.mediumSize,
      mainAxisSpacing: Sizes.mediumSize,
      childAspectRatio: 1.0,
      children: controller.getGridItems().map((item) => _buildGridItem(item)).toList(),
    );
  }

  Widget _buildGridItem(HomeModel item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      child: InkWell(
        onTap: () => controller.navigateTo(item.route),
        child: Padding(
          padding: Insets.mediumPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: Sizes.extraLargeSize, color: item.color),
              SizedBox(height: Sizes.smallSize),
              Text(item.title, style: TextStyles.bodyText1.copyWith(color: item.color), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
