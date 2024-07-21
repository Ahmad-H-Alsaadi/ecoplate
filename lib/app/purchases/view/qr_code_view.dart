import 'package:ecoplate/app/purchases/controller/qr_code_controller.dart';
import 'package:ecoplate/app/purchases/view/purchases_view.dart';
import 'package:ecoplate/core/constants/assets.dart';
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
      title: 'QR Code',
      imagePath: Assets.kQRScanner,
      navigationController: widget.navigationController,
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? rawValue = barcode.rawValue;
            if (rawValue != null && rawValue.isNotEmpty) {
              cameraController?.stop();

              Map<String, dynamic> decodedData = QrCodeController.decodeQrCode(rawValue);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PurchasesView(
                    decodedData: decodedData,
                    navigationController: widget.navigationController,
                  ),
                ),
              );
              break;
            }
          }
        },
      ),
    );
  }
}
