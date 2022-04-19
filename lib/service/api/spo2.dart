import 'dart:convert';
//import 'package:meddashboard/bloc/patient_data_stream_bloc.dart';
import 'package:meddashboard/service/api/api.dart';
import 'package:meddashboard/service/models/Spo2temp_Model.dart';

/// api to get all databaseid
class ApiSpo2 {
  static Future<List<Spo2Model>> getspo2val(String device_id) async {
    final json = jsonDecode(await APIWithFromData.send(
      "spo2Values/getSpo2ValuessByIdweb",
      {'device_id': device_id},
    ));
    List<Spo2Model> arr = [];
    for (final el in json) {
      arr.add(Spo2Model.map2Patient(el));
    }

    //PatientDataStreamBloc.addPatient(data: arr);
    return arr;
  }

  static Future<List<Spo2Model>> getfullspo2val(
      String device_id, String databaseid) async {
    final json = jsonDecode(await APIWithFromData.send(
      "spo2Values/getSpo2ValuessByspo2",
      {'device_id': device_id, 'databaseid': databaseid},
    ));
    List<Spo2Model> arr = [];
    for (final el in json) {
      arr.add(Spo2Model.map2Patient(el));
    }

    //PatientDataStreamBloc.addPatient(data: arr);
    return arr;
  }

  static Future<List<Spo2Model>> getfullspo2date(
      String device_id, String databaseid) async {
    final json = jsonDecode(await APIWithFromData.send(
      "spo2Values/getSpo2ValuessBydate",
      {'device_id': device_id, 'databaseid': databaseid},
    ));
    List<Spo2Model> arr = [];
    for (final el in json) {
      arr.add(Spo2Model.map2Patient(el));
    }

    //PatientDataStreamBloc.addPatient(data: arr);
    return arr;
  }
}
