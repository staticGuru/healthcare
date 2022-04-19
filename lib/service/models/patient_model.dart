import 'dart:async';

import 'package:meddashboard/models/ecg.dart';
import 'package:meddashboard/service/models/device_model.dart';

class PatientModel {
  String id;
  String hospital_id;
  String group_id;
  String patient_name;
  int age;
  String gender;
  String ip_op_io_num;
  int hr_upper_limit;
  int hr_lower_limit;
  int pulse_upper_limit;
  int pulse_lower_limit;
  int spo2_threshold;
  String v;
  List<DeviceModel> devices;
  List<double> ecgData;
  bool pinned;
  String spo2;
  String temp;
  String lungs;
  String heart;
  String heartState;
  EcgModel ecgModel;
  bool alert;

  // final StreamController<EcgModel>  ecg = StreamController.broadcast();

  PatientModel(
      {this.id = "",
      this.hospital_id,
      this.group_id,
      this.patient_name,
      this.age,
      this.gender,
      this.ip_op_io_num,
      this.hr_upper_limit,
      this.hr_lower_limit,
      this.pulse_upper_limit,
      this.pulse_lower_limit,
      this.spo2_threshold,
      this.v,
      this.devices,
      this.pinned = false,
      this.spo2,
      this.temp,
      this.ecgModel,
      this.ecgData,
      this.lungs,
      this.heart,
      this.heartState,
      this.alert = false});

  static PatientModel json2Patient(json) => PatientModel(
        id: json[0].toString(),
        hospital_id: json[1].toString(),
        group_id: json[2].toString(),
        patient_name: json[3].toString(),
        age: json[4],
        gender: json[5].toString(),
        ip_op_io_num: json[6].toString(),
        hr_upper_limit: json[7],
        hr_lower_limit: json[8],
        pulse_upper_limit: json[9],
        pulse_lower_limit: json[10],
        spo2_threshold: json[11],
        v: json[12].toString(),
      );

  static PatientModel map2Patient(data) => PatientModel(
        id: data['_id'].toString(),
        hospital_id: data['hospital_id'].toString(),
        group_id: data['group_id'].toString(),
        patient_name: data['patient_name'].toString(),
        age: data['age'],
        gender: data['gender'].toString(),
        ip_op_io_num: data['ip_op_number'].toString(),
        hr_upper_limit: data['hr_upper_limit'],
        hr_lower_limit: data['hr_lower_limit'],
        pulse_upper_limit: data['pulse_upper_limit'],
        pulse_lower_limit: data['pulse_lower_limit'],
        spo2_threshold: data['spo2_threshold'],
        v: data['__v'].toString(),
        spo2: data['spo2'].toString(),
        temp: data['temp'].toString(),
        heart: data['hr'].toString(),
        lungs: data['rr'].toString(),
        heartState: data['state'].toString(),
      );

  @override
  Map<String, String> toMap() => {
        'id': id,
        'hospital_id': hospital_id,
        'group_id': group_id,
        'patient_name': patient_name,
        'age': age.toString(),
        'gender': gender,
        'ip_op_io_num': ip_op_io_num,
        'hr_upper_limit': hr_upper_limit.toString(),
        'hr_lower_limit': hr_lower_limit.toString(),
        'pulse_upper_limit': pulse_upper_limit.toString(),
        'pulse_lower_limit': pulse_lower_limit.toString(),
        'spo2_threshold': spo2_threshold.toString(),
        '__v': v,
      };
}
