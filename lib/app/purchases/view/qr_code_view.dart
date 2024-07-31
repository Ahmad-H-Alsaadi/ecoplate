import 'package:ecoplate/app/purchases/controller/qr_code_controller.dart';
import 'package:ecoplate/app/purchases/view/purchases_view.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeView extends StatefulWidget {
  final NavigationController navigationController;
  const QRCodeView({super.key, required this.navigationController});

  @override
  _QRCodeViewState createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> with WidgetsBindingObserver {
  MobileScannerController? cameraController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  void _initializeCamera() {
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !mounted) return;
    if (state == AppLifecycleState.inactive) {
      cameraController!.stop();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'QR Code Scanner',
      imagePath: Assets.kQRScanner,
      navigationController: widget.navigationController,
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.kBlack.withOpacity(0.5),
      ),
      child: Center(
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.kPrimaryColor, width: 3),
            borderRadius: Borders.largeBorderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_scanner, size: Sizes.extraLargeSize, color: ColorConstants.kPrimaryColor),
              const SizedBox(height: Sizes.mediumSize),
              Text(
                'Scan QR Code',
                style: TextStyles.heading2.copyWith(color: ColorConstants.kPrimaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        cameraController?.stop();
        Map<String, dynamic> decodedData = QrCodeController.decodeQrCode(rawValue);
        _navigateToPurchasesView(decodedData);
        break;
      }
    }
  }

  void _navigateToPurchasesView(Map<String, dynamic> decodedData) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PurchasesView(
          decodedData: decodedData,
          navigationController: widget.navigationController,
        ),
      ),
    );
  }
}
