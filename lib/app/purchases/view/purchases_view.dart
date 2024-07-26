import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/app/purchases/controller/purchases_controller.dart';
import 'package:ecoplate/app/purchases/model/purchases_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/components/add_item_form.dart';
import 'package:ecoplate/core/components/item_card.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class PurchasesView extends StatefulWidget {
  final NavigationController navigationController;
  final Map<String, dynamic> decodedData;

  const PurchasesView({
    Key? key,
    required this.navigationController,
    required this.decodedData,
  }) : super(key: key);

  @override
  _PurchasesViewState createState() => _PurchasesViewState();
}

class _PurchasesViewState extends State<PurchasesView> {
  late final PurchasesController controller;
  final List<StockModel> items = [];
  List<ItemsModel> savedItems = [];

  @override
  void initState() {
    super.initState();
    controller = PurchasesController(widget.navigationController);
    _loadSavedItems();
  }

  Future<void> _loadSavedItems() async {
    try {
      savedItems = await controller.getSavedItems();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading saved items: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Purchases',
      imagePath: Assets.kPurchases,
      navigationController: widget.navigationController,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Scanned Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...widget.decodedData.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('${entry.key}: ${entry.value}'),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Added Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _showAddExistingItemDialog,
                  child: const Text('Add Existing Item'),
                ),
                ...items.map((item) => ItemCard(
                      item: item,
                      onDelete: () => _removeItem(item),
                    )),
              ],
            ),
          ),
          AddItemForm(onAddItem: _addNewItem),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _savePurchase,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Save Purchase'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.navigateTo('/qr_code_scanner'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Scan Another QR Code'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExistingItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        ItemsModel? selectedItem;
        double amount = 0;
        return AlertDialog(
          title: const Text('Add Existing Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<ItemsModel>(
                hint: const Text('Select an item'),
                value: selectedItem,
                items: savedItems.map((ItemsModel item) {
                  return DropdownMenuItem<ItemsModel>(
                    value: item,
                    child: Text(item.itemName),
                  );
                }).toList(),
                onChanged: (ItemsModel? value) {
                  setState(() {
                    selectedItem = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (selectedItem != null && amount > 0) {
                  _addItem(StockModel(
                    id: '',
                    item: selectedItem!,
                    amount: amount,
                    expireDate: DateTime.now().add(const Duration(days: 30)),
                  ));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewItem(StockModel item) async {
    try {
      await controller.saveItemIfNotExists(item.item);
      _addItem(item);
      await _loadSavedItems(); // Refresh the saved items list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding new item: $e')),
      );
    }
  }

  void _addItem(StockModel item) {
    setState(() {
      items.add(item);
    });
  }

  void _removeItem(StockModel item) {
    setState(() {
      items.remove(item);
    });
  }

  void _savePurchase() async {
    try {
      final purchaseModel = PurchasesModel(
        id: '',
        sellerName: widget.decodedData['seller_name'] ?? '',
        vatNumber: widget.decodedData['vat_number'] ?? '',
        dateTime: DateTime.parse(widget.decodedData['timestamp'] ?? DateTime.now().toIso8601String()),
        totalAmount: double.parse(widget.decodedData['total_amount'] ?? '0'),
        vatAmount: double.parse(widget.decodedData['vat_amount'] ?? '0'),
        items: items,
      );

      await controller.savePurchase(purchaseModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase saved successfully')),
      );
      setState(() {
        items.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving purchase: $e')),
      );
    }
  }
}
