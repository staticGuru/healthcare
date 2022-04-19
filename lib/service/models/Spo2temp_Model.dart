import 'dart:async';

import 'package:meddashboard/models/ecg.dart';
import 'package:meddashboard/service/models/device_model.dart';

class Spo2Model {
  String id;
  String device_id;
  String databaseid;
  List<dynamic> temp;
  List<dynamic> spo2;
  List<dynamic> battery;

  // final StreamController<EcgModel>  ecg = StreamController.broadcast();

  Spo2Model({
    this.id = "",
    this.device_id,
    this.databaseid,
    this.temp,
    this.spo2,
    this.battery,
  });

  static Spo2Model json2Patient(json) => Spo2Model(
        id: json[0].toString(),
        device_id: json[1].toString(),
        databaseid: json[2].toString(),
        temp: json[3],
        spo2: json[4],
        battery: json[5],
      );

  static Spo2Model map2Patient(data) => Spo2Model(
      id: data['_id'].toString(),
      device_id: data['device_id'].toString(),
      databaseid: data['databaseid'].toString(),
      temp: data['temp'],
      spo2: data['spo2'],
      battery: data['battery']);
}
