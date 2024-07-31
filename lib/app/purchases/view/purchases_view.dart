import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/app/purchases/controller/purchases_controller.dart';
import 'package:ecoplate/app/purchases/model/purchases_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/components/add_item_form.dart';
import 'package:ecoplate/core/components/item_card.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
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
      _showSnackBar('Error loading saved items: $e', isError: true);
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
                _buildScannedDataCard(),
                const SizedBox(height: Sizes.mediumSize),
                _buildAddedItemsSection(),
              ],
            ),
          ),
          AddItemForm(onAddItem: _addNewItem),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildScannedDataCard() {
    if (widget.decodedData.isEmpty) {
      return const Card(
        margin: Insets.mediumPadding,
        shape: RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
        elevation: 4,
        child: Padding(
          padding: Insets.mediumPadding,
          child: Center(
            child: Text('No scanned data available', style: TextStyles.bodyText1),
          ),
        ),
      );
    }

    return Card(
      margin: Insets.mediumPadding,
      shape: const RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      elevation: 4,
      child: Padding(
        padding: Insets.mediumPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scanned Data', style: TextStyles.heading2),
            const SizedBox(height: Sizes.smallSize),
            ...widget.decodedData.entries.map((entry) {
              return Padding(
                padding: Insets.smallPadding,
                child: Text('${entry.key}: ${entry.value}', style: TextStyles.bodyText1),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAddedItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: Insets.mediumPadding,
          child: Text('Added Items', style: TextStyles.heading2),
        ),
        _buildAddExistingItemButton(),
        ...items.map((item) => ItemCard(
              item: item,
              onDelete: () => _removeItem(item),
            )),
      ],
    );
  }

  Widget _buildAddExistingItemButton() {
    return Padding(
      padding: Insets.mediumPadding,
      child: ElevatedButton.icon(
        onPressed: _showAddExistingItemDialog,
        icon: const Icon(Icons.add, color: ColorConstants.kWhite),
        label: const Text('Add Existing Item', style: TextStyles.buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.kPrimaryColor,
          padding: Insets.symmetricPadding,
          shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: Insets.mediumPadding,
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton('Save Purchase', _savePurchase, ColorConstants.kPrimaryColor),
          ),
          const SizedBox(width: Sizes.mediumSize),
          Expanded(
            child: _buildActionButton(
                'Scan QR Code', () => controller.navigateTo('/qr_code_scanner'), ColorConstants.kPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: Insets.symmetricPadding,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
      child: Text(text, style: TextStyles.buttonText),
    );
  }

  void _showAddExistingItemDialog() {
    ItemsModel? selectedItem;
    double amount = 0;
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Existing Item', style: TextStyles.heading2),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<ItemsModel>(
                      decoration: Styles.textFieldDecoration.copyWith(
                        labelText: 'Select an item',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      value: selectedItem,
                      items: savedItems.map((ItemsModel item) {
                        return DropdownMenuItem<ItemsModel>(
                          value: item,
                          child: Text(item.itemName, style: TextStyles.bodyText1),
                        );
                      }).toList(),
                      onChanged: (ItemsModel? value) {
                        setState(() {
                          selectedItem = value;
                        });
                      },
                    ),
                    const SizedBox(height: Sizes.mediumSize),
                    TextFormField(
                      controller: amountController,
                      decoration: Styles.textFieldDecoration.copyWith(
                        labelText: 'Amount',
                        suffixText: selectedItem?.measurement ?? '',
                      ),
                      style: TextStyles.bodyText1,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        amount = double.tryParse(value) ?? 0;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel', style: TextStyles.bodyText1.copyWith(color: ColorConstants.kErrorColor)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.kPrimaryColor,
                    shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
                  ),
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
                  child: const Text('Add', style: TextStyles.buttonText),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addNewItem(StockModel item) async {
    try {
      await controller.saveItemIfNotExists(item.item);
      _addItem(item);
      await _loadSavedItems();
    } catch (e) {
      _showSnackBar('Error adding new item: $e', isError: true);
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
      _showSnackBar('Purchase saved successfully');
      setState(() {
        items.clear();
        widget.decodedData.clear();
      });
    } catch (e) {
      _showSnackBar('Error saving purchase: $e', isError: true);
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
