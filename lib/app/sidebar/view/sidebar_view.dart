import 'package:ecoplate/app/sidebar/model/sidebar_model.dart';
import 'package:flutter/material.dart';

class SidebarView extends StatelessWidget {
  final Function(String) onItemTap;
  final VoidCallback onLogout;

  const SidebarView({
    Key? key,
    required this.onItemTap,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'EcoPlate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ...SidebarData.items
              .map(
                (item) => ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  onTap: () {
                    if (item.routeName == '/logout') {
                      onLogout();
                    } else {
                      onItemTap(item.routeName);
                    }
                  },
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
