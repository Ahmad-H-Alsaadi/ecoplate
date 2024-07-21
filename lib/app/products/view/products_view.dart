import 'package:ecoplate/app/products/controller/products_controller.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class ProductsView extends StatefulWidget {
  final NavigationController navigationController;

  const ProductsView({Key? key, required this.navigationController}) : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  late final ProductsController controller;

  @override
  void initState() {
    super.initState();
    controller = ProductsController(widget.navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Products',
      imagePath: Assets.kProducts, // Assuming you have a products icon
      navigationController: widget.navigationController,
      body: Center(
        child: Text("Products"),
      ),
    );
  }
}
