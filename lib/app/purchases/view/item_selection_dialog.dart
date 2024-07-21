// import 'package:ecoplate/app/items/model/items_model.dart';
// import 'package:ecoplate/app/purchases/view/add_item_dialog.dart';
// import 'package:flutter/material.dart';

// class ItemSelectionDialog extends StatefulWidget {
//   final List<ItemsModel> existingItems;
//   const ItemSelectionDialog({Key? key, required this.existingItems}) : super(key: key);

//   @override
//   _ItemSelectionDialogState createState() => _ItemSelectionDialogState();
// }

// class _ItemSelectionDialogState extends State<ItemSelectionDialog> {
//   late List<ItemsModel> items;
//   Set<String> selectedItemIds = {};

//   @override
//   void initState() {
//     super.initState();
//     items = List.from(widget.existingItems);
//     selectedItemIds = Set.from(widget.existingItems.map((e) => e.id));
//     _loadItems();
//   }

//   void _loadItems() async {
//     try {
//       setState(() {
//         items = [...items,  => !selectedItemIds.contains(item.id))];
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load items: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Select Items'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: items
//               .map((item) => CheckboxListTile(
//                     title: Text(item.itemName),
//                     subtitle: Text('VAT: ${item.vatNumber}, Measurement: ${item.measurement}'),
//                     value: selectedItemIds.contains(item.id),
//                     onChanged: (bool? value) {
//                       setState(() {
//                         if (value ?? false) {
//                           selectedItemIds.add(item.id);
//                         } else {
//                           selectedItemIds.remove(item.id);
//                         }
//                       });
//                     },
//                   ))
//               .toList(),
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Text('Add New Item'),
//           onPressed: _addNewItem,
//         ),
//         TextButton(
//           child: Text('OK'),
//           onPressed: () {
//             Navigator.of(context).pop(
//               items.where((item) => selectedItemIds.contains(item.id)).toList(),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   void _addNewItem() async {
//     final newItem = await showDialog<ItemsModel>(
//       context: context,
//       builder: (BuildContext context) {
//         return AddItemDialog();
//       },
//     );
//     if (newItem != null) {
//       setState(() {
//         items.add(newItem);
//         selectedItemIds.add(newItem.id);
//       });
//     }
//   }
// }
