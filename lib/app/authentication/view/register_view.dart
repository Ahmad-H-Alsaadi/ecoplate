import 'package:ecoplate/app/authentication/controller/register_controller.dart';
import 'package:ecoplate/core/components/app_button.dart';
import 'package:ecoplate/core/components/app_text_field.dart';
import 'package:ecoplate/core/components/error_massage.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegisterView extends StatefulWidget {
  final Function()? onTap;
  const RegisterView({super.key, required this.onTap});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterController _registerController = RegisterController();

  @override
  void dispose() {
    _registerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                Assets.kEcoPlate,
                height: LogoConstants.logoHeight * 2,
                width: LogoConstants.logoWidth * 2,
              ),
              const Text(
                "   Lets create an account for you",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              AppTextField(
                controller: _registerController.userNameController,
                hintText: 'User name',
                obscureText: false,
                icon: const Icon(Icons.person),
              ),
              // _registerController.userNameController =!""?
              // const ErrorMassage(errorText: ""),
              AppTextField(
                controller: _registerController.emailController,
                hintText: 'Email',
                obscureText: false,
                icon: const Icon(Icons.email_outlined),
              ),
              _registerController.errorEmail == 'Incorrect email'
                  ? ErrorMassage(errorText: _registerController.errorEmail)
                  : const SizedBox.shrink(),
              AppTextField(
                controller: _registerController.passwordController,
                hintText: 'Password',
                obscureText: true,
                icon: const Icon(Icons.lock_outline),
              ),
              _registerController.errorPassword == 'wrong-password'
                  ? ErrorMassage(errorText: _registerController.errorPassword)
                  : const SizedBox.shrink(),
              AppTextField(
                controller: _registerController.confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
                icon: const Icon(Icons.lock_outline),
              ),
              // ErrorMassage(errorText: _registerController.errorConfirmPassword),
              const SizedBox(height: 20),
              AppButton(
                onTap: () async {
                  await _registerController.signUpUser(context);
                },
                sign: "Sign Up",
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login Now",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
