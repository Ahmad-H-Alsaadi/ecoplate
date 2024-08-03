import 'package:ecoplate/app/dashboard/controller/dashboard_controller.dart';
import 'package:ecoplate/app/detect_food_waste/model/detect_food_waste_model.dart';
import 'package:ecoplate/app/stock/model/stock_model.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: Insets.largePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(constraints),
                  const SizedBox(height: Sizes.largeSize),
                  _buildCharts(constraints),
                  const SizedBox(height: Sizes.largeSize),
                  _buildDetailedLists(constraints),
                  const SizedBox(height: Sizes.largeSize),
                  _buildQuickActions(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(BoxConstraints constraints) {
    return Wrap(
      spacing: Sizes.mediumSize,
      runSpacing: Sizes.mediumSize,
      children: [
        _buildSummaryCard(
          'Average Food Waste',
          StreamBuilder<double>(
            stream: controller.getAverageFoodWaste(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '${snapshot.data!.toStringAsFixed(2)}%',
                  style: TextStyles.heading1.copyWith(color: ColorConstants.kAccentColor),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          Icons.delete_outline,
          constraints,
        ),
        _buildSummaryCard(
          'Low Stock Items',
          StreamBuilder<int>(
            stream: controller.getLowStockItemsCount(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '${snapshot.data}',
                  style: TextStyles.heading1.copyWith(color: ColorConstants.kErrorColor),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          Icons.inventory_2_outlined,
          constraints,
        ),
        _buildSummaryCard(
          'Total Products',
          StreamBuilder<int>(
            stream: controller.getTotalProductsCount(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '${snapshot.data}',
                  style: TextStyles.heading1.copyWith(color: ColorConstants.kPrimaryColor),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          Icons.category_outlined,
          constraints,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, Widget content, IconData icon, BoxConstraints constraints) {
    double cardWidth = constraints.maxWidth > 600 ? (constraints.maxWidth - Sizes.largeSize) / 3 : constraints.maxWidth;
    return Container(
      width: cardWidth,
      padding: Insets.mediumPadding,
      decoration: const BoxDecoration(
        color: ColorConstants.kBackgroundColor,
        borderRadius: Borders.mediumBorderRadius,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyles.bodyText1),
              Icon(icon, color: ColorConstants.kPrimaryColor),
            ],
          ),
          const SizedBox(height: Sizes.smallSize),
          content,
        ],
      ),
    );
  }

  Widget _buildCharts(BoxConstraints constraints) {
    return Wrap(
      spacing: Sizes.mediumSize,
      runSpacing: Sizes.mediumSize,
      children: [
        _buildCard(
          'Food Waste Trend',
          SizedBox(
              height: 300,
              child: StreamBuilder<List<DetectFoodWasteModel>>(
                stream: controller.getFoodWasteStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  final foodWasteData = snapshot.data!;
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[300],
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < foodWasteData.length) {
                                return Text(
                                  DateFormat('MM/dd').format(foodWasteData[value.toInt()].timestamp),
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: const Text('Waste Percentage', style: TextStyle(fontSize: 12)),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      minX: 0,
                      maxX: foodWasteData.length - 1.0,
                      minY: 0,
                      maxY: 40,
                      lineBarsData: [
                        LineChartBarData(
                          spots: foodWasteData.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value.wastePercentage);
                          }).toList(),
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: Colors.blue,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
                        ),
                      ],
                    ),
                  );
                },
              )),
          constraints,
        ),
        _buildCard(
          'Stock Overview',
          SizedBox(
            height: 300,
            child: StreamBuilder<List<StockModel>>(
              stream: controller.getStockStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                int totalItems = snapshot.data!.length;
                int lowStockItems = snapshot.data!.where((item) => item.amount < 10).length;
                return PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: ColorConstants.kPrimaryColor,
                        value: (totalItems - lowStockItems).toDouble(),
                        title: 'Normal',
                        radius: 100,
                        titleStyle: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite),
                      ),
                      PieChartSectionData(
                        color: ColorConstants.kErrorColor,
                        value: lowStockItems.toDouble(),
                        title: 'Low',
                        radius: 110,
                        titleStyle: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite),
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                );
              },
            ),
          ),
          constraints,
        ),
      ],
    );
  }

  Widget _buildDetailedLists(BoxConstraints constraints) {
    return Wrap(
      spacing: Sizes.mediumSize,
      runSpacing: Sizes.mediumSize,
      children: [
        _buildCard(
          'Recent Food Waste',
          StreamBuilder<List<DetectFoodWasteModel>>(
            stream: controller.getFoodWasteStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return Column(
                children: snapshot.data!.take(5).map((waste) {
                  return ListTile(
                    title: Text(waste.productName, style: TextStyles.bodyText1),
                    subtitle: Text('Waste: ${waste.wastePercentage.toStringAsFixed(2)}%', style: TextStyles.bodyText2),
                    trailing: Text(DateFormat('MM/dd/yyyy').format(waste.timestamp), style: TextStyles.bodyText2),
                  );
                }).toList(),
              );
            },
          ),
          constraints,
        ),
        _buildCard(
          'Low Stock Items',
          StreamBuilder<List<StockModel>>(
            stream: controller.getStockStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final lowStockItems = snapshot.data!.where((item) => item.amount < 10).toList();
              return Column(
                children: lowStockItems.take(5).map((item) {
                  return ListTile(
                    title: Text(item.item.itemName, style: TextStyles.bodyText1),
                    subtitle: Text('Amount: ${item.amount}', style: TextStyles.bodyText2),
                    trailing: Text('Expires: ${DateFormat('MM/dd/yyyy').format(item.expireDate)}',
                        style: TextStyles.bodyText2),
                  );
                }).toList(),
              );
            },
          ),
          constraints,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      child: Padding(
        padding: Insets.mediumPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Actions', style: TextStyles.heading2),
            const SizedBox(height: Sizes.mediumSize),
            Wrap(
              spacing: Sizes.mediumSize,
              runSpacing: Sizes.mediumSize,
              children: [
                _buildActionButton('Add Food Waste', Icons.camera_alt, () => controller.navigateTo('/camera')),
                _buildActionButton('Add Purchase', Icons.receipt_long, () => controller.navigateTo('/purchases')),
                _buildActionButton('Update Stock', Icons.inventory, () => controller.navigateTo('/stock')),
                _buildActionButton('Food Survey', Icons.poll, () => controller.navigateToFoodSurvey()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget content, BoxConstraints constraints) {
    double cardWidth =
        constraints.maxWidth > 600 ? (constraints.maxWidth - Sizes.mediumSize) / 2 : constraints.maxWidth;
    return Container(
      width: cardWidth,
      padding: Insets.mediumPadding,
      decoration: const BoxDecoration(
        color: ColorConstants.kBackgroundColor,
        borderRadius: Borders.mediumBorderRadius,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.heading2),
          const SizedBox(height: Sizes.mediumSize),
          content,
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: ColorConstants.kWhite),
      label: Text(text, style: TextStyles.buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.kPrimaryColor,
        padding: Insets.symmetricPadding,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
    );
  }
}
