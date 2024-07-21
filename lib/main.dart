import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/authentication/controller/default_firebase_options.dart';
import 'package:ecoplate/app/home/view/splash_view.dart';
import 'package:ecoplate/core/controllers/locator.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await FirebaseFirestore.instance.collection('test').doc('testDoc').set({'test': 'data'});
    print('Test write to Firestore successful');
  } catch (e) {
    print('Test write to Firestore failed: $e');
  }
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final NavigationController navigationController;

  MyApp({Key? key}) : super(key: key) {
    navigationController = NavigationController(navigatorKey: navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Eco Plate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashView(navigationController: navigationController),
    );
  }
}
