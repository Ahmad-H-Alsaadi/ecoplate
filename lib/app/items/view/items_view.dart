import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoplate/app/items/controller/items_controller.dart';
import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
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
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No items found'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final item = ItemsModel.fromFirestore(snapshot.data!.docs[index]);
                return DisplayItem(
                  item: item,
                  onDelete: () {
                    // Implement delete functionality if needed
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add),
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
                const SnackBar(content: Text('Item added successfully')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error adding item: $e')),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(item.itemName),
        subtitle: Text('VAT: ${item.vatNumber}'),
        trailing: Text(item.measurement),
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
      title: const Text('Add New Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _vatNumberController,
              decoration: const InputDecoration(labelText: 'VAT Number'),
              validator: (value) => value!.isEmpty ? 'Please enter VAT Number' : null,
            ),
            TextFormField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
              validator: (value) => value!.isEmpty ? 'Please enter Item Name' : null,
            ),
            TextFormField(
              controller: _measurementController,
              decoration: const InputDecoration(labelText: 'Measurement'),
              validator: (value) => value!.isEmpty ? 'Please enter Measurement' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add'),
        ),
      ],
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
