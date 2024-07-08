import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../home/view/home_view.dart';
import 'login_or_register_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // User is not logged in, show the login page
            return const LoginOrRegisterView();
          } else {
            // User is logged in, show the product listing page
            return HomeView();
          }
        } else {
          // Still loading, show a loading indicator
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
