import 'package:camera/camera.dart';
import 'package:ecoplate/app/security_cameras/view/camera_view.dart';
import 'package:ecoplate/app/security_cameras/view/security_cameras_view.dart';
import 'package:ecoplate/core/components/eco_plate_appbar.dart';
import 'package:ecoplate/core/components/icon_button_with_title.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';

class DetectFoodWasteView extends StatefulWidget {
  const DetectFoodWasteView({super.key});

  @override
  State<DetectFoodWasteView> createState() => _DetectFoodWasteViewState();
}

class _DetectFoodWasteViewState extends State<DetectFoodWasteView> {
  late CameraController _controller;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.medium);
    await _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const EcoPlateAppbar(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButtonWithTitle(
              icon: Icons.videocam,
              title: "Security Camera",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecurityCamerasView()),
                );
              },
            ),
            const SizedBox(
              width: Sizes.largeSize,
            ),
            IconButtonWithTitle(
              icon: Icons.camera_alt,
              title: "Phone Camera",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraView(controller: _controller)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
