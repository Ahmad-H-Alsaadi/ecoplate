import 'package:ecoplate/app/detect_food_waste/controller/detect_food_waste_controller.dart';
import 'package:ecoplate/core/components/icon_button_with_title.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
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
              'Choose a camera to detect food waste',
              style: TextStyles.heading2.copyWith(color: ColorConstants.kPrimaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Sizes.largeSize),
            _buildCameraButton(
              icon: Icons.camera_alt,
              title: "Phone Camera",
              onTap: () => controller.navigateToPhoneCamera(context),
            ),
            SizedBox(height: Sizes.mediumSize),
            _buildCameraButton(
              icon: Icons.videocam,
              title: "Security Camera",
              onTap: () {
                // TODO: Implement security camera functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Security camera feature coming soon!'),
                    backgroundColor: ColorConstants.kAccentColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraButton({
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
          shape: RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: Sizes.iconSize, color: ColorConstants.kWhite),
            SizedBox(height: Sizes.smallSize),
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
