import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meddashboard/SocketUtils/SocketEmitName.dart';
import 'package:meddashboard/fragments/group.dart';
import 'package:meddashboard/fragments/stats.dart';
import 'package:meddashboard/layout/side_bar.dart';
import 'package:meddashboard/models/card.dart';
import 'package:meddashboard/service/api/device.dart';
import 'package:meddashboard/service/api/group.dart';
import 'package:meddashboard/service/api/patients.dart';
import 'package:meddashboard/service/models/HeartStateLiveModel.dart';
import 'package:meddashboard/service/models/SocketEmitModel.dart';
import 'package:meddashboard/service/models/device_model.dart';
import 'package:meddashboard/service/models/group_model.dart';
import 'package:meddashboard/service/models/hopital_model.dart';
import 'package:meddashboard/service/models/patient_model.dart';
import '../main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class MainScreen extends StatefulWidget {
  final HospitalModel hospital;
  static List<CardModel> allPatients = [];
  static List<CardModel> pinedPatients = [];

  MainScreen(this.hospital);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  IO.Socket socket;
  static GroupDataModel group;
  static List<GroupDataModel> sspd;

  static String hospitalid = "";

  // static String hospitalid = '5f9289edaf1047062c2f7a56';

  static Future getgroup() async {
    sspd = await ApiGroup.getallgroup(hospitalid);
    group = group;
    return sspd;
  }

  getAllPatient() async {
    List<PatientModel> patients = await ApiPatient.getAllPatient(hospitalid);

    MainScreen.allPatients.clear();

    List<CardModel> allPatients = [];

    patients.forEach((element) async {
      List<DeviceModel> deviceList = [];

      await AddDevice.getDevice(element.id)
          .then((value) => deviceList.addAll(value));

      allPatients.add(CardModel(
        element,
        devices: deviceList,
        pinned: false,
      ));
    });

    setState(() {
      MainScreen.allPatients = allPatients;
    });
  }

  List<HeartStateLiveModel> selectedGroupAlert = [];

  void setPatients(GroupDataModel val) {
    for (var el in sspd) {
      if (val != null && el.groupName == val.groupName)
        el.active = true;
      else
        el.active = false;
    }

    group = val;
    checkGroupAlert();
    setState(() {});
    // if (group != null) GroupFragment.getPatient();
  }

  void checkGroupAlert() {
    List<HeartStateLiveModel> data = [];

    if (group != null) {
      for (var el in alertList) {
        if (group.id == el.groupId) {
          data.add(el);
        }
      }
    }

    setState(() {
      selectedGroupAlert = data;
    });
  }

  Future setData() async {
    await getAllPatient();
    getLiveAlert();
  }

  List<HeartStateLiveModel> alertList = [];

  void getLiveAlert() {

    socket = IO.io(SocketEmitName.socketURL,
        OptionBuilder().setTransports(['websocket']).build());

    socket.connect();

    socket.on(SocketEmitName.data, (data) {
      // print(data);

      final liveData = jsonDecode(data);

      SocketEmitModel checkType = SocketEmitModel.fromJson(liveData);

      switch (checkType.emitName) {
        case SocketEmitName.alert:
          print('socket received emit name--->' + SocketEmitName.alert);
          HeartStateLiveModel responseRateLiveModel =
              HeartStateLiveModel.fromJson(liveData);

          if (responseRateLiveModel.patientRecord != 'Normal') {

            var contain = alertList.where((element) => element.patientId == responseRateLiveModel.patientId);

            if (contain.isEmpty) {

              alertList.add(responseRateLiveModel);

              checkGroupAlert();
              setState(() {});

            }

          } else {
            var contain = alertList.where((element) =>
                element.patientId == responseRateLiveModel.patientId);

            if (contain.isNotEmpty) {
              alertList.removeWhere((item) => item.patientId == responseRateLiveModel.patientId);
              checkGroupAlert();

              setState(() {});

            }
          }

          break;

        default:
          break;
      }
    });

    socket.onDisconnect((_) => print('disconnect'));

  }

  @override
  void initState() {
    hospitalid = widget.hospital.hospitalId;
    setData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getgroup(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          final List<GroupDataModel> sspd = snapshot.data;
          List<GroupDataModel> arrr = [];
          if (sspd != null) {
            for (final i in sspd) {
              arrr.add(
                GroupDataModel(
                  id: i.id,
                  hospitalId: i.hospitalId,
                  groupName: i.groupName,
                  doctorName: i.doctorName,
                  inCharge: i.inCharge,
                  moreDetails: i.moreDetails,
                  groupEmailAddress: i.groupEmailAddress,
                  groupPhoneNumber: i.groupPhoneNumber,
                  groupPassword: i.groupPassword,
                  createdOn: i.createdOn,
                  v: i.v,
                ),
              );
            }
          }
          if (MediaQuery.of(context).size.width <= 640)
            return Scaffold(
              backgroundColor: Style.bgBlue,
              body: Center(
                child: Text('screen is too small, sorry'),
              ),
            );
          return Scaffold(
            backgroundColor: Style.bgBlue,
            body: Row(
              children: [
                SideBarLayoutComponent(
                  setPatients,
                  arrr,
                  alertList: alertList,
                ),
                Container(
                  height: double.infinity,
                  width: 1,
                  color: Style.darkGrayBlue,
                ),
                Expanded(
                  child: group == null
                      ? StatsFragment(
                          groupList: arrr,
                          hospitalId: hospitalid,
                          alertList: alertList,
                        )
                      : GroupFragment(
                          group,
                          setPatients,
                          arrr,
                          alertList: selectedGroupAlert,
                        ),
                )
              ],
            ),
          );
        });
  }
}
