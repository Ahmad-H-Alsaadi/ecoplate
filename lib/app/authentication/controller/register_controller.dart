import 'package:ecoplate/app/home/view/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String errorEmail = '';
  String errorPassword = '';
  String errorConfirmPassword = '';

  Future<void> signUpUser(BuildContext context) async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Navigate to HomeScreen upon successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      } else {
        errorConfirmPassword = 'Passwords don\'t match!';
        // Use setState if within a StatefulWidget to update the UI
        (context as Element).markNeedsBuild();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorEmail = 'Email is already in use';
        errorPassword = '';
      } else if (e.code == 'invalid-email') {
        errorEmail = 'Invalid email address';
        errorPassword = '';
      } else if (e.code == 'weak-password') {
        errorPassword = 'The password provided is too weak';
        errorEmail = '';
      } else {
        errorEmail = 'An unknown error occurred';
        errorPassword = '';
      }
      // Use setState if within a StatefulWidget to update the UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      errorEmail = 'An unknown error occurred';
      errorPassword = '';
      (context as Element).markNeedsBuild();
    }
  }

  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
