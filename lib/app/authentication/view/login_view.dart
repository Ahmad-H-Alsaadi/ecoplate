import 'package:ecoplate/app/authentication/controller/login_controller.dart';
import 'package:ecoplate/core/components/app_button.dart';
import 'package:ecoplate/core/components/app_text_field.dart';
import 'package:ecoplate/core/components/error_massage.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final Function()? onTap;
  final NavigationController navigationController;
  const LoginView({super.key, required this.onTap, required this.navigationController});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = LoginController();

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: Insets.allMargin,
                  padding: Insets.allPadding,
                  child: Image.asset(
                    Assets.kEcoPlate,
                  ),
                ),
                AppTextField(
                  controller: _loginController.emailController,
                  hintText: 'Email',
                  obscureText: false,
                  icon: const Icon(Icons.email_outlined),
                ),
                ErrorMassage(errorText: _loginController.errorEmail),
                AppTextField(
                  controller: _loginController.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  icon: const Icon(Icons.lock_outline),
                ),
                ErrorMassage(errorText: _loginController.errorPassword),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: ColorConstants.kBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onTap: () async {
                    await _loginController.signInUser(
                      context,
                      setState,
                      widget.navigationController,
                    );
                  },
                  sign: "Sign In",
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
