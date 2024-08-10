import 'package:ecoplate/app/authentication/controller/register_controller.dart';
import 'package:ecoplate/core/components/app_button.dart';
import 'package:ecoplate/core/components/app_text_field.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  final Function()? onTap;
  final NavigationController navigationController;

  const RegisterView({
    Key? key,
    required this.onTap,
    required this.navigationController,
  }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterController _registerController = RegisterController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match";
        _isLoading = false;
      });
      return;
    }

    try {
      await _registerController.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );
      widget.navigationController.navigateTo('/home');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      if (FirebaseAuth.instance.currentUser != null) {
        widget.navigationController.navigateTo('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                Assets.kEcoPlate,
                height: LogoConstants.logoHeight * 2,
                width: LogoConstants.logoWidth * 2,
              ),
              const SizedBox(height: 20),
              const Text(
                "Let's create an account for you",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _nameController,
                hintText: 'User name',
                obscureText: false,
                icon: const Icon(Icons.person),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
                icon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
                icon: const Icon(Icons.lock_outline),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
                icon: const Icon(Icons.lock_outline),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : AppButton(
                      onTap: _register,
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
