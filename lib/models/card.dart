import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/demoData.dart';
import 'package:meddashboard/models/ecg.dart';
import 'package:meddashboard/service/models/device_model.dart';
import 'package:meddashboard/service/models/patient_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CardModel {
  String name = 'John Doe';
  int age = 36;
  int battery = 10;
  int battery2 = 60;
  String patientId = 'ES0029891';
  int heart = 73;
  String heartState = 'Normal';
  String o2 = '97';
  String temperature = '97.6';
  int lungs = 15;

  bool pinned = false;
  bool bad = false;
  PatientModel patient;
  List<DeviceModel> devices;
  List<double> newECGData = [];
  List<double> oldECGData = [];


  final StreamController<EcgModel>  ecg = StreamController.broadcast();


  CardModel(PatientModel flip, {this.bad = false, this.battery, this.devices, this.pinned = false,}) {
    name = flip.patient_name;
    age = flip.age;
    patientId = flip.id;
    patient = flip;
    patient.devices = this.devices;

    if (bad) {
      heart = 45;
      o2 = '89';
      lungs = 12;
      temperature = '37.3';
      heartState = 'Bradycardia';
    }

    getEcgModel1500().pipe(ecg);


  }

  static IconData getIcon(int battery) {
    if (battery <= 20) {
      return MdiIcons.battery20;
    } else if (battery > 20 && battery <= 60) {
      return MdiIcons.battery60;
    } else if (battery > 60 && battery <= 100) {
      return MdiIcons.battery;
    } else {
      return MdiIcons.batteryAlert;
    }
  }
}
