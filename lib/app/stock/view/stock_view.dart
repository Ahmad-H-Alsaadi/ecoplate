import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/app/stock/controller/stock_controller.dart';
import 'package:intl/intl.dart';

class StockView extends StatefulWidget {
  final NavigationController navigationController;
  const StockView({super.key, required this.navigationController});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  final StockController _stockController = StockController();

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Stock',
      imagePath: Assets.kStock,
      navigationController: widget.navigationController,
      body: StreamBuilder<List<StockModel>>(
        stream: _stockController.getStockStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stock items found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final stockItem = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(stockItem.item.itemName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${stockItem.amount} ${stockItem.item.measurement}'),
                      Text('Expires: ${DateFormat('yyyy-MM-dd').format(stockItem.expireDate)}'),
                    ],
                  ),
                  trailing: Text(
                    '${_getDaysUntilExpiry(stockItem.expireDate)} days left',
                    style: TextStyle(
                      color: _getExpiryColor(stockItem.expireDate),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  int _getDaysUntilExpiry(DateTime expiryDate) {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  Color _getExpiryColor(DateTime expiryDate) {
    final daysLeft = _getDaysUntilExpiry(expiryDate);
    if (daysLeft <= 3) {
      return Colors.red;
    } else if (daysLeft <= 7) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
