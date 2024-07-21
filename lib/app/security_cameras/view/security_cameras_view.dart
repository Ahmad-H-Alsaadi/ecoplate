import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class SecurityCamerasView extends StatefulWidget {
  final NavigationController navigationController;
  const SecurityCamerasView({super.key, required this.navigationController});

  @override
  State<SecurityCamerasView> createState() => _SecurityCamerasViewState();
}

class _SecurityCamerasViewState extends State<SecurityCamerasView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Security Cameras',
      imagePath: Assets.kSecurityCameras,
      navigationController: widget.navigationController,
      body: const Center(
        child: Text("Security Cameras"),
      ),
    );
  }
}
