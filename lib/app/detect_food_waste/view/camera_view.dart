import 'dart:ui' as ui;

import 'package:ecoplate/app/detect_food_waste/controller/camera_controller.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/core/components/bounding_box_painter.dart';
import 'package:ecoplate/core/constants/assets.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  final NavigationController navigationController;
  const CameraView({Key? key, required this.navigationController}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final CameraController _controller = CameraController();
  ProductsModel? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Food Waste Detector',
      imagePath: Assets.kCamera,
      navigationController: widget.navigationController,
      body: StreamBuilder<List<ProductsModel>>(
        stream: _controller.productsStream,
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
            return const Center(child: Text('No products available', style: TextStyles.bodyText1));
          }

          List<ProductsModel> products = snapshot.data!;

          return SingleChildScrollView(
            padding: Insets.largePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton(
                  onPressed: () async {
                    await _controller.openCamera();
                    setState(() {});
                  },
                  icon: Icons.camera_alt,
                  label: 'Open Camera',
                ),
                const SizedBox(height: Sizes.mediumSize),
                _buildButton(
                  onPressed: () async {
                    await _controller.openGallery();
                    setState(() {});
                  },
                  icon: Icons.photo_library,
                  label: 'Choose from Gallery',
                ),
                const SizedBox(height: Sizes.largeSize),
                if (_controller.image != null) ...[
                  _buildImageCard(),
                  const SizedBox(height: Sizes.mediumSize),
                  _buildProductDropdown(products),
                  const SizedBox(height: Sizes.mediumSize),
                  if (_selectedProduct != null) ...[
                    _buildActionButton(
                      onPressed: _saveProductWaste,
                      label: 'Save Product Waste',
                      color: ColorConstants.kPrimaryColor,
                    ),
                    const SizedBox(height: Sizes.smallSize),
                    _buildActionButton(
                      onPressed: _saveAndReduceProductWaste,
                      label: 'Save & Reduce Product Waste',
                      color: ColorConstants.kPrimaryColor,
                    ),
                  ],
                ] else
                  const Text('No image selected', style: TextStyles.bodyText1, textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: ColorConstants.kWhite),
      label: Text(label, style: TextStyles.buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.kPrimaryColor,
        padding: Insets.mediumPadding,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
    );
  }

  Widget _buildImageCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      color: ColorConstants.kCardBackground,
      child: Padding(
        padding: Insets.mediumPadding,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: Borders.smallBorderRadius,
              child: FutureBuilder<ui.Image>(
                future: _controller.getImage(_controller.image!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        double aspectRatio = snapshot.data!.width / snapshot.data!.height;
                        double targetWidth = constraints.maxWidth;
                        double targetHeight = targetWidth / aspectRatio;

                        return Container(
                          width: targetWidth,
                          height: targetHeight,
                          decoration: BoxDecoration(
                            borderRadius: Borders.smallBorderRadius,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Image.file(_controller.image!, fit: BoxFit.contain),
                              CustomPaint(
                                size: Size(targetWidth, targetHeight),
                                painter: BoundingBoxPainter(_controller.boxes, snapshot.data!),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    print("Error loading image: ${snapshot.error}");
                    return const Text("Error loading image");
                  } else {
                    return const CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
                  }
                },
              ),
            ),
            const SizedBox(height: Sizes.mediumSize),
            Text(
              _controller.detectionResult,
              style: TextStyles.heading2.copyWith(color: ColorConstants.kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDropdown(List<ProductsModel> products) {
    return Container(
      padding: Insets.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.kPrimaryColor),
        borderRadius: Borders.smallBorderRadius,
        color: ColorConstants.kWhite,
      ),
      child: DropdownButton<ProductsModel>(
        value: _selectedProduct,
        items: products.map((product) {
          return DropdownMenuItem<ProductsModel>(
            value: product,
            child: Text(product.productName, style: TextStyles.bodyText1),
          );
        }).toList(),
        onChanged: (ProductsModel? selectedProduct) {
          setState(() {
            _selectedProduct = selectedProduct;
          });
        },
        style: TextStyles.bodyText1,
        dropdownColor: ColorConstants.kCardBackground,
        isExpanded: true,
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: Insets.symmetricPadding,
        shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
      child: Text(label, style: TextStyles.buttonText),
    );
  }

  void _saveProductWaste() async {
    if (_selectedProduct == null) return;
    _performAction(_controller.saveProductWaste, 'Product waste saved successfully');
  }

  void _saveAndReduceProductWaste() async {
    if (_selectedProduct == null) return;
    _performAction(_controller.saveAndReduceProductWaste, 'Product waste saved and recipe reduced successfully');
  }

  void _performAction(Future<void> Function(ProductsModel, double) action, String successMessage) async {
    setState(() {
      _controller.isLoading = true;
    });

    try {
      double wastePercentage = double.parse(_controller.detectionResult.split(': ')[1].replaceAll('%', ''));
      await action(_selectedProduct!, wastePercentage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage, style: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite)),
          backgroundColor: ColorConstants.kAccentColor,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
        ),
      );

      setState(() {
        _selectedProduct = null;
      });
    } catch (e) {
      print('Error performing action: $e');
      String errorMessage = 'Failed to perform action. Please try again.';
      if (e.toString().contains('Product not found')) {
        errorMessage = 'Product not found in database. Please refresh your product list.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, style: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite)),
          backgroundColor: ColorConstants.kErrorColor,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
        ),
      );
    } finally {
      setState(() {
        _controller.isLoading = false;
      });
    }
  }
}
