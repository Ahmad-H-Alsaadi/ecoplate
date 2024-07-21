import 'package:ecoplate/app/authentication/view/register_view.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';

import 'login_view.dart';

class LoginOrRegisterView extends StatefulWidget {
  final NavigationController navigationController;
  const LoginOrRegisterView({
    super.key,
    required this.navigationController,
  });

  @override
  State<LoginOrRegisterView> createState() => _LoginOrRegisterViewState();
}

class _LoginOrRegisterViewState extends State<LoginOrRegisterView> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginView(
        onTap: togglePages,
        navigationController: widget.navigationController,
      );
    } else {
      return RegisterView(
        onTap: togglePages,
        navigationController: widget.navigationController,
      );
    }
  }
}
