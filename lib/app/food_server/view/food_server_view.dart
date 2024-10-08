import 'package:ecoplate/app/food_server/controller/food_server_controller.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
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
  List<ProductsModel> allProducts = [];

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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ProductsModel>>(
                stream: controller.getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyles.bodyText1));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: ColorConstants.kPrimaryColor));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found', style: TextStyles.bodyText1));
                  }

                  allProducts = snapshot.data!;
                  return ListView.builder(
                    itemCount: allProducts.length,
                    itemBuilder: (context, index) {
                      final product = allProducts[index];
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
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: Insets.mediumPadding,
      child: ElevatedButton(
        onPressed: _saveOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.kPrimaryColor,
          shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
          padding: Insets.symmetricPadding,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, color: ColorConstants.kWhite),
            SizedBox(width: Sizes.smallSize),
            Text('Save Order', style: TextStyles.buttonText),
          ],
        ),
      ),
    );
  }

  void _saveOrder() async {
    try {
      List<ProductsModel> orderSelections = selections.entries
          .where((entry) => entry.value > 0)
          .map((entry) => allProducts.firstWhere((product) => product.productName == entry.key))
          .toList();

      if (orderSelections.isEmpty) {
        _showSnackBar('Please select at least one product', isError: true);
        return;
      }

      await controller.saveOrder(orderSelections, selections);
      _showSnackBar('Order saved successfully');
      setState(() {
        selections.clear();
      });
    } catch (e) {
      _showSnackBar('Error saving order: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite)),
        backgroundColor: isError ? ColorConstants.kErrorColor : ColorConstants.kAccentColor,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
    );
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
      margin: Insets.symmetricMargin,
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      child: Padding(
        padding: Insets.mediumPadding,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.productName, style: TextStyles.heading2),
                  const SizedBox(height: Sizes.smallSize),
                  Text('Recipe items: ${product.recipe.length}', style: TextStyles.bodyText2),
                ],
              ),
            ),
            _buildQuantityControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: const BoxDecoration(
        color: ColorConstants.kCardBackground,
        borderRadius: Borders.smallBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(Icons.remove, () => onQuantityChanged(quantity > 0 ? quantity - 1 : 0)),
          const SizedBox(width: Sizes.mediumSize),
          Text('$quantity', style: TextStyles.bodyText1),
          const SizedBox(width: Sizes.mediumSize),
          _buildControlButton(Icons.add, () => onQuantityChanged(quantity + 1)),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: Insets.smallPadding,
        decoration: const BoxDecoration(
          color: ColorConstants.kPrimaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: ColorConstants.kWhite, size: Sizes.iconSize),
      ),
    );
  }
}
