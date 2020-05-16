import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//import 'package:mlkit/mlkit.dart';

class TextDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<VisionText> _texts;
  TextDetectDecoration(List<VisionText> texts, Size originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return new TextDetectPainter(_texts, _originalImageSize);
  }
}

class TextDetectPainter extends BoxPainter {
  final List<VisionText> _texts;
  final Size _originalImageSize;
  TextDetectPainter(texts, originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = new Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    print("original Image Size : ${_originalImageSize}");

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;

    /*
    for (var text in _texts) {

      text.
      print("text : ${text.text}, rect : ${text.rect}");
      final _rect = Rect.fromLTRB(
          offset.dx + text.rect.left / _widthRatio,
          offset.dy + text.rect.top / _heightRatio,
          offset.dx + text.rect.right / _widthRatio,
          offset.dy + text.rect.bottom / _heightRatio);
      //final _rect = Rect.fromLTRB(24.0, 115.0, 75.0, 131.2);
      print("_rect : ${_rect}");
      canvas.drawRect(_rect, paint);
    }
*/
    for (var text in _texts) {
      for (TextBlock block in text.blocks){
        for (TextLine line in block.lines){
          print('Line : '+line.text + '\n');
        }
      }
    }

    print("offset : ${offset}");
    print("configuration : ${configuration}");

    final rect = offset & configuration.size;

    print("rect container : ${rect}");

    //canvas.drawRect(rect, paint);
    canvas.restore();
  }
}
