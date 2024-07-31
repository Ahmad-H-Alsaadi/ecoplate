import 'package:ecoplate/app/sidebar/controller/sidebar_controller.dart';
import 'package:ecoplate/app/sidebar/model/sidebar_model.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';

class SidebarView extends StatelessWidget {
  final Function(String) onItemTap;
  const SidebarView({Key? key, required this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SidebarController(onItemTap: onItemTap);
    return Drawer(
      child: Container(
        color: ColorConstants.kBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              _buildWelcomeSection(controller),
              const Divider(height: 1, thickness: 1),
              Expanded(child: _buildMenuItems(controller, context)),
              _buildLogoutButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(SidebarController controller) {
    return StreamBuilder<String>(
      stream: controller.getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
        }
        String userName = snapshot.data ?? 'User';
        return Container(
          padding: Insets.allPadding,
          color: ColorConstants.kBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: Sizes.mediumSize),
              CircleAvatar(
                radius: 40,
                backgroundColor: ColorConstants.kPrimaryColor,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: TextStyles.heading1.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: Sizes.mediumSize),
              Text(userName, style: TextStyles.heading2.copyWith(color: ColorConstants.kPrimaryColor)),
              const SizedBox(height: Sizes.smallSize),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItems(SidebarController controller, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: controller.getRegularItems().map((item) => _buildMenuItem(item, controller, context)).toList(),
    );
  }

  Widget _buildMenuItem(SidebarModel item, SidebarController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: Icon(item.icon, color: ColorConstants.kPrimaryColor),
          title: Text(item.title, style: TextStyles.bodyText1),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => controller.handleItemTap(context, item),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(SidebarController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text('Log out', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.kErrorColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 3,
        ),
        onPressed: controller.signUserOut,
      ),
    );
  }
}
