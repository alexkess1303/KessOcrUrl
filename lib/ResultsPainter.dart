import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//import 'package:mlkit/mlkit.dart';

class ResultsPainter extends CustomPainter {
  final ui.Image image;
  final List<VisionText> currentLabels;

  ResultsPainter(this.image, this.currentLabels);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..color = Colors.yellow;


    canvas.drawImage(image, Offset.zero, Paint());
  }
  @override
  bool shouldRepaint(ResultsPainter oldDelegate) {
    return image != oldDelegate.image;
  }
}