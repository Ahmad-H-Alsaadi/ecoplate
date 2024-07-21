import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';

class EcoPlateAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? imagePath;
  final NavigationController navigationController;

  const EcoPlateAppbar({Key? key, this.imagePath, required this.navigationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorConstants.kBackgroundColor,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: IconButton(
          icon: const Icon(Icons.menu, color: ColorConstants.kPrimaryColor, size: 40),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: imagePath != null
          ? Image.asset(
              imagePath!,
              height: LogoConstants.logoHeight / 2.5,
              fit: BoxFit.contain,
            )
          : null,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: ColorConstants.kPrimaryColor,
              size: 40,
            ),
            onPressed: () {
              navigationController.navigateTo('/account');
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
