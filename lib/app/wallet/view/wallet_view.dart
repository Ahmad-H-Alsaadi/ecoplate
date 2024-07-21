import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class WalletView extends StatefulWidget {
  final NavigationController navigationController;
  const WalletView({super.key, required this.navigationController});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Wallet',
      imagePath: Assets.kWallet,
      navigationController: widget.navigationController,
      body: const Center(
        child: Text("Wallet"),
      ),
    );
  }
}
