import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> boxes;
  final ui.Image image;

  BoundingBoxPainter(this.boxes, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.kAccentColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final labelPaint = Paint()
      ..color = ColorConstants.kPrimaryColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    double scaleX = size.width / image.width;
    double scaleY = size.height / image.height;
    double scale = math.min(scaleX, scaleY);

    for (var box in boxes) {
      List<double> bbox = List<double>.from(box['bbox']);
      double x1 = bbox[0] * scale;
      double y1 = bbox[1] * scale;
      double x2 = bbox[2] * scale;
      double y2 = bbox[3] * scale;

      final rect = Rect.fromLTRB(x1, y1, x2, y2);
      canvas.drawRect(rect, paint);

      final labelText = '${box['class']}: ${(box['confidence'] * 100).toStringAsFixed(0)}%';
      textPainter.text = TextSpan(
        text: labelText,
        style: TextStyles.bodyText2.copyWith(
          color: ColorConstants.kWhite,
          fontSize: 12,
        ),
      );
      textPainter.layout();

      final labelBackgroundRect = Rect.fromLTWH(
        x1,
        y1 - textPainter.height - 4,
        textPainter.width + 8,
        textPainter.height + 4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelBackgroundRect, const Radius.circular(4)),
        labelPaint,
      );

      textPainter.paint(canvas, Offset(x1 + 4, y1 - textPainter.height - 2));
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return boxes != oldDelegate.boxes || image != oldDelegate.image;
  }
}
