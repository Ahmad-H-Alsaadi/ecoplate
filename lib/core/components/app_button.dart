import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function()? onTap;
  final String sign;

  const AppButton({super.key, required this.onTap, required this.sign});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: Insets.symmetricPadding,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConstants.kLogoColor,
        ),
        child: Center(
          child: Text(
            sign,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
