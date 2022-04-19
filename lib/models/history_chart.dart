import 'package:flutter/material.dart';

class HistoryChartInteractionModel extends ChangeNotifier {
  double _offset = 0;

  double widthDrag;
  bool drag;
  HistoryChartType lastUpdate;
  final double width;

  set offsetFromStrip(double offset) {
    _offset = offset;
    lastUpdate = HistoryChartType.strip;
    notifyListeners();
  }

  set offsetFromBig(double offset) {
    _offset = offset;
    lastUpdate = HistoryChartType.big;
    notifyListeners();
  }

  get offset => _offset;

  get stripWidth => width / 10000 * width;

  HistoryChartInteractionModel(this.width);
}

enum HistoryChartType { big, strip }
