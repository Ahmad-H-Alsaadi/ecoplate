import 'package:ecoplate/app/account/controller/account_controller.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountView extends StatelessWidget {
  final NavigationController navigationController;

  const AccountView({Key? key, required this.navigationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountController(),
      child: Consumer<AccountController>(
        builder: (context, controller, _) {
          return BaseView(
            title: 'Account',
            imagePath: Assets.kAccount,
            navigationController: navigationController,
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator(color: ColorConstants.kPrimaryColor))
                : Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: Insets.largePadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildTextField(controller.nameController, 'Name', Icons.person),
                            const SizedBox(height: Sizes.mediumSize),
                            _buildTextField(controller.emailController, 'Email', Icons.email),
                            const SizedBox(height: Sizes.mediumSize),
                            _buildTextField(controller.passwordController, 'New Password', Icons.lock,
                                isPassword: true),
                            const SizedBox(height: Sizes.largeSize),
                            _buildButton('Save Changes', ColorConstants.kPrimaryColor, () async {
                              String message = await controller.saveChanges();
                              _showSnackBar(context, message);
                            }),
                            const SizedBox(height: Sizes.smallSize),
                            _buildButton('Update Password', ColorConstants.kPrimaryColor, () async {
                              String message = await controller.updatePassword();
                              _showSnackBar(context, message);
                            }),
                            const SizedBox(height: Sizes.largeSize),
                            _buildButton('Sign Out', ColorConstants.kErrorColor, () async {
                              await controller.signOut();
                              navigationController.navigateTo('/login');
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: Styles.containerDecoration,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: ColorConstants.kPrimaryColor),
          border: InputBorder.none,
          contentPadding: Insets.symmetricPadding,
        ),
        obscureText: isPassword,
        style: TextStyles.bodyText1,
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: Insets.symmetricPadding,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
      child: Text(text, style: TextStyles.buttonText),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite)),
        backgroundColor: ColorConstants.kPrimaryColor,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
    );
  }
}
