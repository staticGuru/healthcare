import 'dart:async';

import 'package:meddashboard/models/card.dart';
import 'package:meddashboard/service/models/patient_model.dart';
import 'package:rxdart/rxdart.dart';

class PatientDataStreamBloc {
  static StreamController<List<PatientModel>> _patientDataController = BehaviorSubject();

  static Stream<List<PatientModel>> get patientDataListStream =>
      _patientDataController.stream;

  static StreamSink<List<PatientModel>> get _patientDataListSink =>
      _patientDataController.sink;

  static addPatient({List<PatientModel> data}) {
    _patientDataListSink.add(data);
  }

  /// Pinned Data
  static StreamController<List<CardModel>> _pinnedPatientDataController =
      BehaviorSubject();

  static Stream<List<CardModel>> get pinnedPatientDataListStream =>
      _pinnedPatientDataController.stream;

  static StreamSink<List<CardModel>> get _pinnedPatientDataListSink =>
      _pinnedPatientDataController.sink;

  static pinePatient({List<CardModel> data}) {
    _pinnedPatientDataListSink.add(data);
  }

  /// Selected Group Data
  static StreamController<List<CardModel>> _selectedGroupPatientDataController =
      BehaviorSubject();

  static Stream<List<CardModel>> get selectedGroupPatientDataListStream =>
      _selectedGroupPatientDataController.stream;

  static StreamSink<List<CardModel>> get _selectedGroupPatientDataListSink =>
      _selectedGroupPatientDataController.sink;

  static selectedGroupPatient({List<CardModel> data}) {
    _selectedGroupPatientDataListSink.add(data);
  }

  ///socket data
  static StreamController<String> _liveDataController = BehaviorSubject();

  static Stream<String> get livePatientDataListStream =>
      _liveDataController.stream;

  static StreamSink<String> get _livePatientDataListSink =>
      _liveDataController.sink;

  static livePatient({String data}) {
    _livePatientDataListSink.add(data);
  }

  ///count data
  static StreamController<String> _statsCountController = BehaviorSubject();

  static Stream<String> get statsCountDataListStream =>
      _statsCountController.stream;

  static StreamSink<String> get _statsCountDataListSink =>
      _statsCountController.sink;

  static statsCount({String data}) {
    _statsCountDataListSink.add(data);
  }

  dispose() {
    _patientDataController.close();
    _pinnedPatientDataController.close();
    _selectedGroupPatientDataController.close();
    _liveDataController.close();
    _statsCountController.close();
  }
}
