import 'package:ecoplate/app/purchases/controller/purchases_controller.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class PurchasesView extends StatelessWidget {
  final NavigationController navigationController;
  final Map<String, dynamic> decodedData;
  late final PurchasesController controller;

  PurchasesView({Key? key, required this.navigationController, required this.decodedData}) : super(key: key) {
    controller = PurchasesController(navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Purchases',
      imagePath: Assets.kPurchases,
      navigationController: navigationController,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: decodedData.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${entry.key}: ${entry.value}'),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Text('Scan Another QR Code'),
              onPressed: () => controller.navigateTo('/qr_code_scanner'),
            ),
          ),
        ],
      ),
    );
  }
}
