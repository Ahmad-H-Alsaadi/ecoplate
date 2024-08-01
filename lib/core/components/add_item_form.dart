import 'package:ecoplate/app/items/model/items_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddItemForm extends StatefulWidget {
  final Function(StockModel) onAddItem;

  const AddItemForm({Key? key, required this.onAddItem}) : super(key: key);

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  String _measurement = 'kg';
  DateTime _expireDate = DateTime.now().add(const Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: Insets.allMargin,
      shape: const RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      elevation: 4,
      child: Padding(
        padding: Insets.mediumPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_nameController, 'Item Name', Icons.inventory),
              const SizedBox(height: Sizes.mediumSize),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child:
                        _buildTextField(_quantityController, 'Quantity', Icons.scale, isNumber: true, isCompact: true),
                  ),
                  const SizedBox(width: Sizes.smallSize),
                  Expanded(
                    flex: 2,
                    child: _buildDropdown(),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.mediumSize),
              _buildDatePicker(),
              const SizedBox(height: Sizes.largeSize),
              EcoPlateButton(
                onPressed: _submitForm,
                child: const Text('Add Item', style: TextStyles.buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isNumber = false, bool isCompact = false}) {
    return TextFormField(
      controller: controller,
      decoration: Styles.textFieldDecoration.copyWith(
        labelText: label,
        prefixIcon: Icon(icon, color: ColorConstants.kPrimaryColor),
        contentPadding: isCompact ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10) : Insets.symmetricPadding,
      ),
      style: TextStyles.bodyText1,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (isNumber && double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _measurement,
      items: ['kg', 'g', 'L', 'mL', 'pcs'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyles.bodyText1),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _measurement = newValue!;
        });
      },
      decoration: Styles.textFieldDecoration.copyWith(
        labelText: 'Unit',
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      style: TextStyles.bodyText1,
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _expireDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(primary: ColorConstants.kPrimaryColor),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != _expireDate) {
          setState(() {
            _expireDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: Styles.textFieldDecoration.copyWith(
          labelText: 'Expiration Date',
          prefixIcon: const Icon(Icons.calendar_today, color: ColorConstants.kPrimaryColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(DateFormat('yyyy-MM-dd').format(_expireDate), style: TextStyles.bodyText1),
            const Icon(Icons.arrow_drop_down, color: ColorConstants.kPrimaryColor),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newItem = StockModel(
        id: '',
        item: ItemsModel(
          id: '',
          itemName: _nameController.text,
          vatNumber: '',
          measurement: _measurement,
        ),
        amount: double.parse(_quantityController.text),
        expireDate: _expireDate,
      );
      widget.onAddItem(newItem);
      _nameController.clear();
      _quantityController.clear();
      setState(() {
        _expireDate = DateTime.now().add(const Duration(days: 30));
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}

class EcoPlateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const EcoPlateButton({Key? key, required this.onPressed, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.kPrimaryColor,
        padding: Insets.symmetricPadding,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
        minimumSize: const Size(Sizes.buttonWidth, Sizes.buttonHeight),
      ),
      child: child,
    );
  }
}
