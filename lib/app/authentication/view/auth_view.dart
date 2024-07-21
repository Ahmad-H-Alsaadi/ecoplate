import 'package:ecoplate/app/authentication/view/login_or_register_view.dart';
import 'package:ecoplate/app/home/view/home_view.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthView extends StatelessWidget {
  final NavigationController navigationController;

  const AuthView({Key? key, required this.navigationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // User is not logged in, show the login page
            return LoginOrRegisterView(navigationController: navigationController);
          } else {
            // User is logged in, show the home view
            return HomeView(navigationController: navigationController);
          }
        } else {
          // Still loading, show a loading indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
