import 'package:ecoplate/app/stock/controller/stock_controller.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';
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
            return const Center(child: CircularProgressIndicator(color: ColorConstants.kPrimaryColor));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyles.bodyText1.copyWith(color: ColorConstants.kErrorColor)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stock items found.', style: TextStyles.bodyText1));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final stockItem = snapshot.data![index];
              return _buildStockItemCard(stockItem);
            },
          );
        },
      ),
    );
  }

  Widget _buildStockItemCard(StockModel stockItem) {
    return Card(
      margin: Insets.mediumPadding,
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      child: Container(
        decoration: Styles.cardDecoration,
        child: Padding(
          padding: Insets.mediumPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stockItem.item.itemName, style: TextStyles.heading2.copyWith(color: ColorConstants.kPrimaryColor)),
              const SizedBox(height: Sizes.mediumSize),
              _buildInfoRow('Quantity', '${stockItem.amount} ${stockItem.item.measurement}'),
              _buildInfoRow('Expires', DateFormat('yyyy-MM-dd').format(stockItem.expireDate)),
              const SizedBox(height: Sizes.mediumSize),
              _buildExpiryInfo(stockItem.expireDate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: Insets.smallPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.bodyText2.copyWith(color: ColorConstants.kPrimaryColor)),
          Text(value, style: TextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildExpiryInfo(DateTime expiryDate) {
    final daysLeft = _getDaysUntilExpiry(expiryDate);
    final color = _getExpiryColor(expiryDate);
    return Container(
      padding: Insets.mediumPadding,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: Borders.smallBorderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, color: color, size: Sizes.iconSize),
          const SizedBox(width: Sizes.smallSize),
          Text(
            '$daysLeft days left',
            style: TextStyles.bodyText1.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  int _getDaysUntilExpiry(DateTime expiryDate) {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  Color _getExpiryColor(DateTime expiryDate) {
    final daysLeft = _getDaysUntilExpiry(expiryDate);
    if (daysLeft <= 3) {
      return ColorConstants.kErrorColor;
    } else if (daysLeft <= 7) {
      return Colors.orange;
    } else {
      return ColorConstants.kAccentColor;
    }
  }
}
