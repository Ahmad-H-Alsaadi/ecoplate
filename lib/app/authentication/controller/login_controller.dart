import 'package:ecoplate/app/home/view/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorEmail = '';
  String errorPassword = '';

  Future<void> signInUser(BuildContext context, Function setState) async {
    // Set the locale to a specific language code, e.g., 'en' for English
    FirebaseAuth.instance.setLanguageCode('en');

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Clear error messages upon successful login
      setState(() {
        errorEmail = '';
        errorPassword = '';
      });
      // Navigate to another screen or perform further actions after login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()), // Replace with your home screen
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          errorEmail = 'Incorrect email';
          errorPassword = '';
        } else if (e.code == 'wrong-password') {
          errorPassword = 'Incorrect password';
          errorEmail = '';
        } else if (e.code == 'too-many-requests') {
          errorEmail = 'Too many failed login attempts. Please try again later or reset your password.';
          errorPassword = '';
        } else {
          errorEmail = 'An unknown error occurred';
          errorPassword = '';
        }
      });
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
