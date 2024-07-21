import 'package:ecoplate/app/account/controller/account_controller.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
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
            imagePath: 'assets/images/account_icon.png',
            navigationController: navigationController,
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextFormField(
                          controller: controller.emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        TextFormField(
                          controller: controller.passwordController,
                          decoration: const InputDecoration(labelText: 'New Password'),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            String message = await controller.saveChanges();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                          },
                          child: const Text('Save Changes'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            String message = await controller.updatePassword();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                          },
                          child: const Text('Update Password'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            await controller.signOut();
                            navigationController.navigateTo('/login');
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: ColorConstants.kPrimaryColor),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
