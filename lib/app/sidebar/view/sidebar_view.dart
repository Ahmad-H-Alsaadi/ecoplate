import 'package:ecoplate/app/sidebar/controller/sidebar_controller.dart';
import 'package:flutter/material.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';

class SidebarView extends StatelessWidget {
  final Function(String) onItemTap;

  const SidebarView({
    Key? key,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SidebarController(onItemTap: onItemTap);

    return Drawer(
      backgroundColor: ColorConstants.kBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Ahmad',
                style: TextStyle(
                  color: ColorConstants.kBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    Assets.kProfile,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
            ),
            Expanded(
              child: ListView(
                children: controller
                    .getRegularItems()
                    .expand((item) => [
                          ListTile(
                            leading: Icon(item.icon),
                            title: Text(item.title),
                            onTap: () => controller.handleItemTap(context, item),
                          ),
                          const Divider(color: ColorConstants.kBlack),
                        ])
                    .toList(),
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: Icon(controller.getLastItem().icon),
                  title: Text(controller.getLastItem().title),
                  onTap: controller.signUserOut,
                ),
                const SizedBox(height: 10.0)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
