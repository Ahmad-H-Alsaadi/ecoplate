import 'package:flutter/material.dart';

class SidebarModel {
  final IconData icon;
  final String title;
  final String routeName; // Instead of a callback, we'll use route names

  SidebarModel({
    required this.icon,
    required this.title,
    required this.routeName,
  });
}

class SidebarData {
  static final List<SidebarModel> items = [
    SidebarModel(
      icon: Icons.manage_accounts_outlined,
      title: 'Home',
      routeName: '/home',
    ),
    SidebarModel(
      icon: Icons.favorite,
      title: 'Dashboard',
      routeName: '/dashboard',
    ),
    SidebarModel(
      icon: Icons.history,
      title: 'Purchases',
      routeName: '/purchases',
    ),
    SidebarModel(
      icon: Icons.textsms_outlined,
      title: 'Stock',
      routeName: '/stock',
    ),
    SidebarModel(
      icon: Icons.exit_to_app_rounded,
      title: 'Log out',
      routeName: '/logout',
    ),
  ];
}
