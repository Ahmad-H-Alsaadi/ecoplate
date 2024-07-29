import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> boxes;
  final ui.Image image;

  BoundingBoxPainter(this.boxes, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

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

      // Draw label
      textPainter.text = TextSpan(
        text: '${box['class']}: ${(box['confidence'] * 100).toStringAsFixed(0)}%',
        style: TextStyle(color: Colors.red, fontSize: 12, backgroundColor: Colors.white),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x1, y1 - 15));
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return boxes != oldDelegate.boxes || image != oldDelegate.image;
  }
}
