import 'package:ecoplate/app/items/controller/items_controller.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class ItemsView extends StatefulWidget {
  final NavigationController navigationController;

  const ItemsView({Key? key, required this.navigationController}) : super(key: key);

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  late final ItemsController controller;

  @override
  void initState() {
    super.initState();
    controller = ItemsController(widget.navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Items',
      imagePath: Assets.kItems, // Assuming you have an items icon
      navigationController: widget.navigationController,
      body: const Center(
        child: Text("Items"),
      ),
    );
  }
}
