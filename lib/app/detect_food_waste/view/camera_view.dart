import 'dart:ui' as ui;

import 'package:ecoplate/app/detect_food_waste/controller/camera_controller.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/core/components/bounding_box_painter.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Waste Detector', style: TextStyles.heading2),
        backgroundColor: ColorConstants.kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(height: Sizes.mediumSize),
              _buildButton(
                onPressed: () async {
                  await _controller.openGallery();
                  setState(() {});
                },
                icon: Icons.photo_library,
                label: 'Choose from Gallery',
              ),
              SizedBox(height: Sizes.largeSize),
              if (_controller.image != null)
                _buildImageCard()
              else
                Text('No image selected', style: TextStyles.bodyText1, textAlign: TextAlign.center),
            ],
          ),
        ),
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
        shape: RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
      ),
    );
  }

  Widget _buildImageCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: Borders.mediumBorderRadius),
      child: Padding(
        padding: Insets.mediumPadding,
        child: Column(
          children: [
            _buildImage(),
            SizedBox(height: Sizes.mediumSize),
            _controller.isLoading
                ? CircularProgressIndicator(color: ColorConstants.kPrimaryColor)
                : _buildDetectionResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return FutureBuilder<ui.Image>(
      future: _controller.getImage(_controller.image!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return LayoutBuilder(
            builder: (context, constraints) {
              double aspectRatio = snapshot.data!.width / snapshot.data!.height;
              double targetWidth = constraints.maxWidth;
              double targetHeight = targetWidth / aspectRatio;

              return Container(
                width: targetWidth,
                height: targetHeight,
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
        } else {
          return CircularProgressIndicator(color: ColorConstants.kPrimaryColor);
        }
      },
    );
  }

  Widget _buildDetectionResults() {
    return Column(
      children: [
        Text(
          _controller.detectionResult,
          style: TextStyles.heading2.copyWith(color: ColorConstants.kPrimaryColor),
        ),
        SizedBox(height: Sizes.mediumSize),
        Text('Select a product:', style: TextStyles.bodyText1),
        SizedBox(height: Sizes.smallSize),
        _buildProductDropdown(),
        SizedBox(height: Sizes.mediumSize),
        if (_selectedProduct != null)
          ElevatedButton(
            onPressed: _saveProductWaste,
            child: Text('Save Product Waste', style: TextStyles.buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.kAccentColor,
              padding: Insets.symmetricPadding,
              shape: RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
            ),
          ),
      ],
    );
  }

  Widget _buildProductDropdown() {
    return Container(
      padding: Insets.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.kPrimaryColor),
        borderRadius: Borders.smallBorderRadius,
      ),
      child: DropdownButton<ProductsModel>(
        value: _selectedProduct,
        items: _controller.products.map((product) {
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
        underline: SizedBox(),
      ),
    );
  }

  void _saveProductWaste() async {
    if (_selectedProduct == null) return;

    setState(() {
      _controller.isLoading = true;
    });

    try {
      double wastePercentage = double.parse(_controller.detectionResult.split(': ')[1].replaceAll('%', ''));
      await _controller.saveProductWaste(_selectedProduct!, wastePercentage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product waste saved successfully',
              style: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite)),
          backgroundColor: ColorConstants.kAccentColor,
        ),
      );

      setState(() {
        _selectedProduct = null;
      });
    } catch (e) {
      print('Error saving product waste: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save product waste. Please try again.',
              style: TextStyles.bodyText2.copyWith(color: ColorConstants.kWhite)),
          backgroundColor: ColorConstants.kErrorColor,
        ),
      );
    } finally {
      setState(() {
        _controller.isLoading = false;
      });
    }
  }
}
