import 'dart:convert';
import 'package:meddashboard/bloc/patient_data_stream_bloc.dart';
import 'package:meddashboard/service/api/api.dart';
import 'package:meddashboard/service/models/patient_model.dart';

/// api to get all patient under a group
class ApiPatient {
  // static getPatientByGroup(String groupid, String hospitalId) async {
  //   final json = jsonDecode(await APIWithFromData.send(
  //     "patient/getAllPatientsById",
  //     {
  //       'hospital_id': hospitalId,
  //       'group_id': groupid,
  //     },
  //   ));
  //   List<PatientModel> arr = [];
  //   for (final el in json) {
  //     arr.add(PatientModel.map2Patient(el));
  //   }
  //   PatientDataStreamBloc.addPatient(data: arr);
  // }

  ///api to add new patient details
  static addNewPatients(PatientModel patient) async {
    await API.send(
      'patient/addPatient',
      jsonEncode(patient.toMap()).toString(),
    );
  }

  ///api to delete patient details
  static deletePatients(String patientId) async {
    await APIWithFromData.send(
      'patient/deletePatient',
      {"patient_id": "$patientId"},
    );
  }

  ///api to Update patient details
  static Future updatePatients(PatientModel patient) async {
    final json = await APIWithFromData.send(
      'patient/updatePatient',
      patient.toMap(),
    );
    return PatientModel.json2Patient(json);
  }

  static Future<List<PatientModel>> getAllPatient(String hospitalId) async {
    final json = jsonDecode(await APIWithFromData.send(
      "patient/getAllPatientsByhospitalId",
      {'hospital_id': hospitalId},
    ));
    List<PatientModel> arr = [];
    for (final el in json) {
      arr.add(PatientModel.map2Patient(el));
    }
    PatientDataStreamBloc.addPatient(data: arr);
    return arr;
  }
}
