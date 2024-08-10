import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/home/model/home_model.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController {
  final NavigationController navigationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomeController(this.navigationController);

  void navigateTo(String routeName) {
    navigationController.navigateTo(routeName);
  }

  List<HomeModel> getGridItems() {
    return HomeData.items;
  }

  Stream<String> getUserName() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return snapshot.data()?['name'] ?? 'User';
        } else {
          return 'User';
        }
      });
    } else {
      return Stream.value('User');
    }
  }
}
