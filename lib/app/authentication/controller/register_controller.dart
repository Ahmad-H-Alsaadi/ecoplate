import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/services/database_service.dart';
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
  String? userId;
  String? passwordStrengthMessage;
  DatabaseService dbService = DatabaseService(userId: 'some_user_id');

  bool isPasswordStrong(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      passwordStrengthMessage = null;
    } else if (password.length < 8) {
      passwordStrengthMessage = 'Password must be at least 8 characters long';
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      passwordStrengthMessage = 'Password must contain at least one uppercase letter';
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      passwordStrengthMessage = 'Password must contain at least one lowercase letter';
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      passwordStrengthMessage = 'Password must contain at least one number';
    } else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      passwordStrengthMessage = 'Password must contain at least one special character';
    } else {
      passwordStrengthMessage = 'Strong password';
    }
  }

  Future<void> signUpUser(BuildContext context, Function setState, NavigationController navigationController) async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        // Create user in Firebase Auth
        UserCredential userCredential;
        try {
          userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
        } catch (e) {
          print('Error creating user: $e');
          throw e;
        }

        String userId = userCredential.user!.uid;
        print('User created in Firebase Auth with userId: $userId');

        // Update display name
        try {
          await FirebaseAuth.instance.currentUser?.updateDisplayName(userNameController.text);
          print('Display name updated for userId: $userId');
        } catch (e) {
          print('Error updating display name: $e');
          throw e;
        }

        // Save user data to Firestore
        try {
          DatabaseService dbService = DatabaseService(userId: userId);
          await dbService.updateUserData(userNameController.text, emailController.text);
          print('User data saved to Firestore for userId: $userId');
        } catch (e) {
          print('Error saving user data to Firestore: $e');
          throw e;
        }

        // If all steps complete successfully, you can navigate here
        navigationController.navigateTo('/home');
      } else {
        setState(() {
          errorConfirmPassword = 'Passwords do not match';
        });
      }
    } catch (e) {
      // Handle errors
      print('Error in signUpUser: $e');
      // Update UI with error message
      setState(() {
        errorEmail = 'An error occurred during sign up';
        errorPassword = '';
      });
    }
  }

  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
