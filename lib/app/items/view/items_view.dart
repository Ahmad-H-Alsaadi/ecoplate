import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/items/controller/items_controller.dart';
import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return Scaffold(
      body: BaseView(
        title: 'Items',
        imagePath: Assets.kItems,
        navigationController: widget.navigationController,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('items')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong', style: TextStyles.bodyText1));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: ColorConstants.kPrimaryColor));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No items found', style: TextStyles.bodyText1));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final item = ItemsModel.fromFirestore(snapshot.data!.docs[index]);
                return DisplayItem(
                  item: item,
                  onDelete: () {},
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        backgroundColor: ColorConstants.kPrimaryColor,
        child: const Icon(Icons.add, color: ColorConstants.kWhite),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddItemDialog(
          onItemAdded: (ItemsModel newItem) async {
            try {
              await controller.addItem(newItem);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item added successfully',
                      style: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite)),
                  backgroundColor: ColorConstants.kAccentColor,
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Error adding item: $e', style: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite)),
                  backgroundColor: ColorConstants.kErrorColor,
                ),
              );
            }
          },
        );
      },
    );
  }
}

class DisplayItem extends StatelessWidget {
  final ItemsModel item;
  final Function() onDelete;

  const DisplayItem({Key? key, required this.item, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: Insets.symmetricMargin,
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      child: ListTile(
        contentPadding: Insets.mediumPadding,
        title: Text(item.itemName, style: TextStyles.heading2),
        subtitle: Text('VAT: ${item.vatNumber}', style: TextStyles.bodyText2),
        trailing: Text(item.measurement, style: TextStyles.bodyText1),
      ),
    );
  }
}

class AddItemDialog extends StatefulWidget {
  final Function(ItemsModel) onItemAdded;

  const AddItemDialog({Key? key, required this.onItemAdded}) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _vatNumberController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _measurementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Item', style: TextStyles.heading2),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_vatNumberController, 'VAT Number'),
            const SizedBox(height: Sizes.smallSize),
            _buildTextField(_itemNameController, 'Item Name'),
            const SizedBox(height: Sizes.smallSize),
            _buildTextField(_measurementController, 'Measurement'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyles.bodyText1.copyWith(color: ColorConstants.kErrorColor)),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.kPrimaryColor,
            shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
          ),
          child: const Text('Add', style: TextStyles.buttonText),
        ),
      ],
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newItem = ItemsModel(
        id: '', // Firestore will generate this
        vatNumber: _vatNumberController.text,
        itemName: _itemNameController.text,
        measurement: _measurementController.text,
      );
      widget.onItemAdded(newItem);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _vatNumberController.dispose();
    _itemNameController.dispose();
    _measurementController.dispose();
    super.dispose();
  }
}
