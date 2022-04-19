import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:meddashboard/models/ecg.dart';

import '../main.dart';

class EcgPainter extends CustomPainter {
  EcgModel model;

  EcgPainter(this.model);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    p.strokeWidth = 2;
    p.color = Style.bgBlue;
    //  model.range = 0.0012190259144457;
    // double reffer = 0.0012190259144457;
    // double height = 80;

    double spacing = model.oldData.isNotEmpty
        ? (size.width - 12) / (model.length - 1)
        : (size.width) / (model.length - 1);

    for (int i = 0; i < model.newData.length - 1; i++) {
      canvas.drawLine(
          Offset(spacing * i,
              size.height - (size.height / model.range * model.newData[i])),
          Offset(spacing * (i + 1),
              size.height - (size.height / model.range * model.newData[i + 1])),
          p);
    }
    var plus = spacing * model.newData.length + 8;

    for (int i = 0; i < model.oldData.length - 1; i++) {
      canvas.drawLine(
          Offset(spacing * i + plus,
              size.height - (size.height / model.range * model.oldData[i])),
          Offset(spacing * (i + 1) + plus,
              size.height - (size.height / model.range * model.oldData[i + 1])),
          p);
    }
  }

  // @override
  // bool shouldRepaint(EcgPainter oldDelegate) =>
  //     oldDelegate.model != oldDelegate.model.length;
  @override
  bool shouldRepaint(EcgPainter oldDelegate) =>
      model != oldDelegate.model || model.length != oldDelegate.model.length;
}
