import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/sidebar/model/sidebar_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SidebarController {
  final Function(String) onItemTap;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SidebarController({required this.onItemTap});

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

  void signUserOut() async {
    await _auth.signOut();
    onItemTap('/login');
  }

  void handleItemTap(BuildContext context, SidebarModel item) {
    onItemTap(item.routeName);
  }

  List<SidebarModel> getRegularItems() {
    return SidebarData.items.take(SidebarData.items.length - 1).toList();
  }

  SidebarModel getLastItem() {
    return SidebarData.items.last;
  }
}
