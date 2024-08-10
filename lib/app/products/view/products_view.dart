import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/app/products/controller/products_controller.dart';
import 'package:ecoplate/app/products/model/recipe_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductsView extends StatefulWidget {
  final NavigationController navigationController;
  const ProductsView({Key? key, required this.navigationController}) : super(key: key);
  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  late final ProductsController controller;
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final List<RecipeModel> _recipe = [];

  @override
  void initState() {
    super.initState();
    controller = ProductsController(widget.navigationController);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Products',
      imagePath: Assets.kProducts,
      navigationController: widget.navigationController,
      body: SingleChildScrollView(
        child: Padding(
          padding: Insets.largePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_productNameController, 'Product Name'),
                const SizedBox(height: Sizes.mediumSize),
                const Text('Recipe Items:', style: TextStyles.heading2),
                const SizedBox(height: Sizes.smallSize),
                ..._recipe.map(_buildRecipeItem),
                const SizedBox(height: Sizes.mediumSize),
                Row(
                  children: [
                    Expanded(
                      child: _buildButton('Add Recipe Item', _showItemSelectionDialog),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.mediumSize),
                Row(
                  children: [
                    Expanded(
                      child: _buildButton('Create Product', _createProduct),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(borderRadius: Borders.smallBorderRadius),
        filled: true,
        fillColor: ColorConstants.kCardBackground,
      ),
      style: TextStyles.bodyText1,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildRecipeItem(RecipeModel item) {
    return Card(
      margin: Insets.smallPadding,
      shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      child: ListTile(
        title: Text(item.item.itemName, style: TextStyles.bodyText1),
        subtitle: Text('Amount: ${item.amount} ${item.item.measurement}', style: TextStyles.bodyText2),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: ColorConstants.kErrorColor),
          onPressed: () {
            setState(() {
              _recipe.remove(item);
            });
          },
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.kPrimaryColor,
        padding: Insets.mediumPadding,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
      child: Text(text, style: TextStyles.buttonText),
    );
  }

  void _showItemSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItemSelectionDialog(
          onItemSelected: (ItemsModel selectedItem) {
            Navigator.of(context).pop();
            _showSetAmountDialog(selectedItem);
          },
        );
      },
    );
  }

  void _showSetAmountDialog(ItemsModel selectedItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SetAmountDialog(
          item: selectedItem,
          onAmountSet: (double amount) {
            setState(() {
              int existingIndex = _recipe.indexWhere((element) => element.item.id == selectedItem.id);
              if (existingIndex != -1) {
                _recipe[existingIndex] = RecipeModel(
                  item: selectedItem,
                  amount: _recipe[existingIndex].amount + amount,
                );
                _showSnackBar('Updated amount for ${selectedItem.itemName}');
              } else {
                _recipe.add(RecipeModel(
                  item: selectedItem,
                  amount: amount,
                ));
                _showSnackBar('Added ${selectedItem.itemName} to recipe');
              }
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _createProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_recipe.isEmpty) {
        _showSnackBar('Please add at least one item to the recipe', isError: true);
        return;
      }
      try {
        await controller.createProduct(_productNameController.text, _recipe);
        _showSnackBar('Product created successfully');
        _productNameController.clear();
        setState(() {
          _recipe.clear();
        });
      } catch (e) {
        String errorMessage = 'Error creating product';
        if (e is Exception) {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }
        _showSnackBar(errorMessage, isError: true);
      }
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

class ItemSelectionDialog extends StatelessWidget {
  final Function(ItemsModel) onItemSelected;

  const ItemSelectionDialog({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select an Item', style: TextStyles.heading2),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('items')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong', style: TextStyles.bodyText1);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: ColorConstants.kPrimaryColor));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No items found', style: TextStyles.bodyText1);
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                ItemsModel item = ItemsModel.fromFirestore(snapshot.data!.docs[index]);
                return ListTile(
                  title: Text(item.itemName, style: TextStyles.bodyText1),
                  subtitle: Text(item.measurement, style: TextStyles.bodyText2),
                  onTap: () => onItemSelected(item),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class SetAmountDialog extends StatefulWidget {
  final ItemsModel item;
  final Function(double) onAmountSet;

  const SetAmountDialog({Key? key, required this.item, required this.onAmountSet}) : super(key: key);

  @override
  _SetAmountDialogState createState() => _SetAmountDialogState();
}

class _SetAmountDialogState extends State<SetAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Amount for ${widget.item.itemName}', style: TextStyles.heading2),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Amount (${widget.item.measurement})',
            border: const OutlineInputBorder(borderRadius: Borders.smallBorderRadius),
            filled: true,
            fillColor: ColorConstants.kCardBackground,
          ),
          style: TextStyles.bodyText1,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyles.bodyText1.copyWith(color: ColorConstants.kErrorColor)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAmountSet(double.parse(_amountController.text));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.kPrimaryColor,
            shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
          ),
          child: const Text('Set', style: TextStyles.buttonText),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
