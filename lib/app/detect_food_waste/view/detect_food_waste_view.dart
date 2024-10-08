import 'package:ecoplate/app/detect_food_waste/controller/detect_food_waste_controller.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/constants/icon_constants.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class DetectFoodWasteView extends StatefulWidget {
  final NavigationController navigationController;
  const DetectFoodWasteView({Key? key, required this.navigationController}) : super(key: key);

  @override
  State<DetectFoodWasteView> createState() => _DetectFoodWasteViewState();
}

class _DetectFoodWasteViewState extends State<DetectFoodWasteView> {
  late DetectFoodWasteController controller;

  @override
  void initState() {
    super.initState();
    controller = DetectFoodWasteController(widget.navigationController);
    _initCamera();
  }

  Future<void> _initCamera() async {
    await controller.initCameras();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Detect Food Waste',
      imagePath: Assets.kDetectWaste,
      navigationController: widget.navigationController,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose an option',
              style: TextStyles.heading2.copyWith(color: ColorConstants.kPrimaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.largeSize),
            _buildButton(
              icon: IconConstants.kCamera,
              title: "Phone Camera",
              onTap: () => controller.navigateToPhoneCamera(context),
            ),
            const SizedBox(height: Sizes.mediumSize),
            _buildButton(
              icon: IconConstants.kSurvey,
              title: "Food Survey",
              onTap: () => controller.navigateToFoodSurvey(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 200,
      margin: Insets.smallPadding,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.kPrimaryColor,
          padding: Insets.mediumPadding,
          shape: const RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: Sizes.iconSize, color: ColorConstants.kWhite),
            const SizedBox(height: Sizes.smallSize),
            Text(
              title,
              style: TextStyles.bodyText1.copyWith(color: ColorConstants.kWhite),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
