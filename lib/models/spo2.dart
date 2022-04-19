import 'dart:math';

class Spo2tempModel {
  List<double> newData;
  List<double> oldData;
  int lastShownPosition;

  double range;

  int length = 1500;

  Spo2tempModel({this.newData, this.oldData, this.lastShownPosition}) {
    update();
  }

  void update() {
    if (oldData.isNotEmpty) {
      final minNew = newData.reduce(min);
      final minOld = oldData.reduce(min);
      final minValue = min(minNew, minOld);
      final maxNew = newData.reduce(max);
      final maxOld = oldData.reduce(max);
      final maxValue = max(maxNew, maxOld);
      newData = newData.map((e) => e != null ? e -= minValue : null).toList();
      oldData = oldData.map((e) => e != null ? e -= minValue : null).toList();
      range = maxValue - minValue;
    } else {
      final minValue = newData.reduce(min);

      final maxValue = newData.reduce(max);

      newData = newData.map((e) => e != null ? e -= minValue : null).toList();
      oldData = oldData.map((e) => e != null ? e -= minValue : null).toList();

      range = maxValue - minValue;
    }
  }
}
