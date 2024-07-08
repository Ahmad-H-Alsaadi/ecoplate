import 'package:ecoplate/app/authentication/view/register_view.dart';
import 'package:flutter/material.dart';
import 'login_view.dart';

class LoginOrRegisterView extends StatefulWidget {
  const LoginOrRegisterView({super.key});

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
      );
    } else {
      return RegisterView(
        onTap: togglePages,
      );
    }
  }
}
