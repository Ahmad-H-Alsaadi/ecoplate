import 'package:camera/camera.dart';
import 'package:ecoplate/core/components/eco_plate_appbar.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  final CameraController controller;
  const CameraView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const EcoPlateAppbar(),
      body: Column(
        children: [
          SizedBox(child: CameraPreview(controller)),
        ],
      ),
    );
  }
}
