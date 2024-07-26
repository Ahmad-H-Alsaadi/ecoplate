import 'package:ecoplate/app/food_server/controller/food_server_controller.dart';
import 'package:ecoplate/app/food_server/model/food_server_model.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class FoodServerView extends StatefulWidget {
  final NavigationController navigationController;
  const FoodServerView({Key? key, required this.navigationController}) : super(key: key);

  @override
  State<FoodServerView> createState() => _FoodServerViewState();
}

class _FoodServerViewState extends State<FoodServerView> {
  late final FoodServerController controller;
  final Map<String, int> selections = {};

  @override
  void initState() {
    super.initState();
    controller = FoodServerController(widget.navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView(
        title: 'Food Server',
        imagePath: Assets.kFoodServer,
        navigationController: widget.navigationController,
        body: StreamBuilder<List<ProductsModel>>(
          stream: controller.getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return DisplayProduct(
                  product: product,
                  quantity: selections[product.productName] ?? 0,
                  onQuantityChanged: (newQuantity) {
                    setState(() {
                      selections[product.productName] = newQuantity;
                    });
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveOrder,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _saveOrder() async {
    try {
      List<FoodServerSelection> orderSelections = selections.entries
          .where((entry) => entry.value > 0)
          .map((entry) => FoodServerSelection(productId: entry.key, quantity: entry.value))
          .toList();

      if (orderSelections.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one product')),
        );
        return;
      }

      await controller.saveOrder(orderSelections);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order saved successfully')),
      );
      setState(() {
        selections.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving order: $e')),
      );
    }
  }
}

class DisplayProduct extends StatelessWidget {
  final ProductsModel product;
  final int quantity;
  final Function(int) onQuantityChanged;

  const DisplayProduct({
    Key? key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(product.productName),
        subtitle: Text('Recipe items: ${product.recipe.length}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => onQuantityChanged(quantity > 0 ? quantity - 1 : 0),
            ),
            Text('$quantity'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onQuantityChanged(quantity + 1),
            ),
          ],
        ),
      ),
    );
  }
}
