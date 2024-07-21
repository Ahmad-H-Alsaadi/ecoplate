// lib/app/security_cameras/view/detect_food_waste_view.dart

import 'package:ecoplate/app/security_cameras/controller/detect_food_waste_controller.dart';
import 'package:ecoplate/core/components/icon_button_with_title.dart';
import 'package:ecoplate/core/constants/assets.dart';
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButtonWithTitle(
              icon: Icons.videocam,
              title: "Security Camera",
              onTap: () => controller.navigateToSecurityCameras(context),
            ),
            const SizedBox(width: Sizes.largeSize),
            IconButtonWithTitle(
              icon: Icons.camera_alt,
              title: "Phone Camera",
              onTap: () => controller.navigateToPhoneCamera(context),
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
