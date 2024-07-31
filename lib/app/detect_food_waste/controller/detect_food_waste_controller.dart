import 'package:camera/camera.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';

class DetectFoodWasteController {
  final NavigationController navigationController;
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  DetectFoodWasteController(this.navigationController);

  Future<void> initCameras() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      cameraController = CameraController(cameras![0], ResolutionPreset.medium);
      await cameraController!.initialize();
    }
  }

  void navigateToPhoneCamera(BuildContext context) {
    if (cameraController != null && cameraController!.value.isInitialized) {
      navigationController.navigateTo('/camera', arguments: {'controller': cameraController});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not initialized')),
      );
    }
  }

  void navigateToFoodSurvey(BuildContext context) {
    navigationController.navigateTo('/food_survey');
  }

  void dispose() {
    cameraController?.dispose();
  }
}
