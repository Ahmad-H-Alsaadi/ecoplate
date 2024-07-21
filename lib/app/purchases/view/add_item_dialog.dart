// import 'package:ecoplate/app/items/model/items_model.dart';
// import 'package:flutter/material.dart';

// class AddItemDialog extends StatefulWidget {
//   @override
//   _AddItemDialogState createState() => _AddItemDialogState();
// }

// class _AddItemDialogState extends State<AddItemDialog> {
//   final _formKey = GlobalKey<FormState>();

//   String vatNumber = '';
//   String itemName = '';
//   String measurement = '';

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add New Item'),
//       content: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             TextFormField(
//               decoration: InputDecoration(labelText: 'VAT Number'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a VAT number';
//                 }
//                 return null;
//               },
//               onSaved: (value) => vatNumber = value!,
//             ),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Item Name'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter an item name';
//                 }
//                 return null;
//               },
//               onSaved: (value) => itemName = value!,
//             ),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Measurement'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a measurement';
//                 }
//                 return null;
//               },
//               onSaved: (value) => measurement = value!,
//             ),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Text('Cancel'),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         TextButton(
//           child: Text('Add'),
//           onPressed: () async {
//             if (_formKey.currentState!.validate()) {
//               _formKey.currentState!.save();
//               final newItem = ItemsModel(
//                 id: '', // Firestore will generate the ID
//                 vatNumber: vatNumber,
//                 itemName: itemName,
//                 measurement: measurement,
//               );
//               try {
//                 final addedItem = await _itemsService.addItem(newItem);
//                 Navigator.of(context).pop(addedItem);
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Failed to add item: $e')),
//                 );
//               }
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
