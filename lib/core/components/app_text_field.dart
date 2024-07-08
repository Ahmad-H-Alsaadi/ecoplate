import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Insets.symmetricPadding,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: icon,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kBlack),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kBlack),
          ),
          fillColor: ColorConstants.kBackgroundColor,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: ColorConstants.kBlack),
        ),
      ),
    );
  }
}
