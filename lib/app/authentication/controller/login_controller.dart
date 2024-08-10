import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorEmail = '';
  String errorPassword = '';

  Future<void> signInUser(BuildContext context, Function setState, NavigationController navigationController) async {
    FirebaseAuth.instance.setLanguageCode('en');
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      setState(() {
        errorEmail = '';
        errorPassword = '';
      });
      navigationController.navigateTo('/home');
    } catch (e) {
      setState(() {
        errorEmail = 'An unknown error occurred';
        errorPassword = '';
      });
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
