import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:flutter/material.dart';

class QuantityEditDialog extends StatefulWidget {
  final int initialQuantity;

  const QuantityEditDialog({Key? key, required this.initialQuantity, required ItemsModel item}) : super(key: key);

  @override
  _QuantityEditDialogState createState() => _QuantityEditDialogState();
}

class _QuantityEditDialogState extends State<QuantityEditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Quantity'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Quantity'),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            final newQuantity = int.tryParse(_controller.text);
            if (newQuantity != null) {
              Navigator.of(context).pop(newQuantity);
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
