import 'package:ecoplate/app/account/view/account_view.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';

class EcoPlateAppbar extends StatelessWidget implements PreferredSizeWidget {
  const EcoPlateAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0, // Removes shadow for a more modern look
      backgroundColor: ColorConstants.kBackgroundColor,
      leadingWidth: 80, // Gives more space for the menu icon
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: IconButton(
          icon: const Icon(Icons.menu, color: ColorConstants.kPrimaryColor, size: 40),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Image.asset(
        Assets.kEcoPlate,
        height: LogoConstants.logoHeight / 2.5,
        fit: BoxFit.contain,
      ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountView()),
              );
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
