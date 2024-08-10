import 'package:flutter/material.dart';

class IconButtonWithTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const IconButtonWithTitle({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 50),
          Text(title),
        ],
      ),
    );
  }
}
