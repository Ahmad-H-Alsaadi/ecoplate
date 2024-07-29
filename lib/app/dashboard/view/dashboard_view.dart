import 'package:ecoplate/app/dashboard/controller/dashboard_controller.dart';
import 'package:ecoplate/app/detect_food_waste/model/detect_food_waste_model.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/app/purchases/model/purchases_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final NavigationController navigationController;
  late final DashboardController controller;

  DashboardView({Key? key, required this.navigationController}) : super(key: key) {
    controller = DashboardController(navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Dashboard',
      imagePath: Assets.kDashBoard,
      navigationController: navigationController,
      body: SingleChildScrollView(
        child: Padding(
          padding: Insets.largePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFoodWasteSummary(),
              SizedBox(height: Sizes.largeSize),
              _buildRecentFoodWaste(),
              SizedBox(height: Sizes.largeSize),
              _buildStockOverview(),
              SizedBox(height: Sizes.largeSize),
              _buildLatestPurchases(),
              SizedBox(height: Sizes.largeSize),
              _buildProductStatistics(),
              SizedBox(height: Sizes.largeSize),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodWasteSummary() {
    return _buildCard(
      'Food Waste Summary',
      StreamBuilder<List<DetectFoodWasteModel>>(
        stream: controller.getFoodWasteStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No food waste data', style: TextStyles.bodyText1);
          }
          double averageWaste =
              snapshot.data!.map((e) => e.wastePercentage).reduce((a, b) => a + b) / snapshot.data!.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Average Waste: ${averageWaste.toStringAsFixed(2)}%', style: TextStyles.bodyText1),
              SizedBox(height: Sizes.mediumSize),
              Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: snapshot.data!.length.toDouble() - 1,
                    minY: 0,
                    maxY: 100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: snapshot.data!.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.wastePercentage);
                        }).toList(),
                        isCurved: true,
                        color: ColorConstants.kAccentColor,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecentFoodWaste() {
    return _buildCard(
      'Recent Food Waste',
      StreamBuilder<List<DetectFoodWasteModel>>(
        stream: controller.getFoodWasteStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No recent food waste data', style: TextStyles.bodyText1);
          }
          return Column(
            children: snapshot.data!.take(5).map((waste) {
              return ListTile(
                title: Text(waste.productName, style: TextStyles.bodyText1),
                subtitle: Text('Waste: ${waste.wastePercentage.toStringAsFixed(2)}%', style: TextStyles.bodyText2),
                trailing: Text(waste.timestamp.toString().substring(0, 16), style: TextStyles.bodyText2),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildStockOverview() {
    return _buildCard(
      'Stock Overview',
      StreamBuilder<List<StockModel>>(
        stream: controller.getStockStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No stock data', style: TextStyles.bodyText1);
          }
          int totalItems = snapshot.data!.length;
          int lowStockItems = snapshot.data!.where((item) => item.amount < 10).length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Items: $totalItems', style: TextStyles.bodyText1),
              Text('Low Stock Items: $lowStockItems', style: TextStyles.bodyText1),
              SizedBox(height: Sizes.mediumSize),
              Container(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: ColorConstants.kAccentColor,
                        value: (totalItems - lowStockItems).toDouble(),
                        title: 'Normal',
                        radius: 50,
                        titleStyle: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite),
                      ),
                      PieChartSectionData(
                        color: ColorConstants.kErrorColor,
                        value: lowStockItems.toDouble(),
                        title: 'Low',
                        radius: 60,
                        titleStyle: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLatestPurchases() {
    return _buildCard(
      'Latest Purchases',
      StreamBuilder<List<PurchasesModel>>(
        stream: controller.getPurchasesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No purchase data', style: TextStyles.bodyText1);
          }
          double totalAmount = snapshot.data!.map((p) => p.totalAmount).reduce((a, b) => a + b);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Spent: \$${totalAmount.toStringAsFixed(2)}', style: TextStyles.bodyText1),
              Text('Number of Purchases: ${snapshot.data!.length}', style: TextStyles.bodyText1),
              SizedBox(height: Sizes.mediumSize),
              ...snapshot.data!.take(3).map((purchase) {
                return ListTile(
                  title: Text(purchase.sellerName, style: TextStyles.bodyText1),
                  subtitle: Text('\$${purchase.totalAmount.toStringAsFixed(2)}', style: TextStyles.bodyText2),
                  trailing: Text(purchase.dateTime.toString().substring(0, 10), style: TextStyles.bodyText2),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductStatistics() {
    return _buildCard(
      'Product Statistics',
      StreamBuilder<List<ProductsModel>>(
        stream: controller.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No product data', style: TextStyles.bodyText1);
          }
          int totalProducts = snapshot.data!.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Products: $totalProducts', style: TextStyles.bodyText1),
              SizedBox(height: Sizes.mediumSize),
              Text('Top Products:', style: TextStyles.bodyText1),
              ...snapshot.data!.take(5).map((product) {
                return ListTile(
                  title: Text(product.productName, style: TextStyles.bodyText1),
                  trailing: Text('${product.recipe.length} recipes', style: TextStyles.bodyText2),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton('Add Food Waste', () => controller.navigateTo('/camera')),
        _buildActionButton('Add Purchase', () => controller.navigateTo('/purchases')),
        _buildActionButton('Update Stock', () => controller.navigateTo('/stock')),
      ],
    );
  }

  Widget _buildCard(String title, Widget content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      child: Padding(
        padding: Insets.mediumPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles.heading2),
            SizedBox(height: Sizes.mediumSize),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.kPrimaryColor,
        padding: Insets.symmetricPadding,
        shape: RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
      child: Text(text, style: TextStyles.buttonText),
    );
  }
}
