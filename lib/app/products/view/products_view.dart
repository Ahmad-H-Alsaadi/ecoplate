import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/app/products/controller/products_controller.dart';
import 'package:ecoplate/app/products/model/recipe_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text('Recipe Items:', style: Theme.of(context).textTheme.titleMedium),
                ..._recipe.map((item) => ListTile(
                      title: Text(item.item.itemName),
                      subtitle: Text('Amount: ${item.amount} ${item.item.measurement}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _recipe.remove(item);
                          });
                        },
                      ),
                    )),
                ElevatedButton(
                  onPressed: _showItemSelectionDialog,
                  child: const Text('Add Recipe Item'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createProduct,
                  child: const Text('Create Product'),
                ),
              ],
            ),
          ),
        ),
      ),
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
                // Item already exists, update its amount
                _recipe[existingIndex] = RecipeModel(
                  item: selectedItem,
                  amount: _recipe[existingIndex].amount + amount,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated amount for ${selectedItem.itemName}')),
                );
              } else {
                // Add new item to recipe
                _recipe.add(RecipeModel(
                  item: selectedItem,
                  amount: amount,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added ${selectedItem.itemName} to recipe')),
                );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one item to the recipe')),
        );
        return;
      }
      try {
        await controller.createProduct(_productNameController.text, _recipe);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully')),
        );
        // Clear the form
        _productNameController.clear();
        setState(() {
          _recipe.clear();
        });
      } catch (e) {
        String errorMessage = 'Error creating product';
        if (e is Exception) {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }
}

class ItemSelectionDialog extends StatelessWidget {
  final Function(ItemsModel) onItemSelected;

  const ItemSelectionDialog({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select an Item'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300, // Set a fixed height or use a flexible height based on your needs
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('items')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No items found');
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                ItemsModel item = ItemsModel.fromFirestore(snapshot.data!.docs[index]);
                return ListTile(
                  title: Text(item.itemName),
                  subtitle: Text(item.measurement),
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
      title: Text('Set Amount for ${widget.item.itemName}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          decoration: InputDecoration(labelText: 'Amount (${widget.item.measurement})'),
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAmountSet(double.parse(_amountController.text));
            }
          },
          child: const Text('Set'),
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
