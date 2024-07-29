import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecoplate/app/sidebar/model/sidebar_model.dart';

class SidebarController {
  final Function(String) onItemTap;

  SidebarController({required this.onItemTap});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
