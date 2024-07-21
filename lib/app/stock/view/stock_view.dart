import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class StockView extends StatefulWidget {
  final NavigationController navigationController;
  const StockView({super.key, required this.navigationController});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Stock',
      imagePath: Assets.kStock,
      navigationController: widget.navigationController,
      body: Center(
        child: Text("Stock"),
      ),
    );
  }
}
