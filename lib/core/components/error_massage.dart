import 'package:flutter/material.dart';

class ErrorMassage extends StatelessWidget {
  const ErrorMassage({super.key, required this.errorText});
  final String errorText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Text(
            errorText,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
