import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/bloc/patient_data_stream_bloc.dart';
import 'package:meddashboard/components/patients_grid.dart';
import 'package:meddashboard/screens/change_password.dart';
import 'package:meddashboard/screens/getting_started/sign_in.dart';
import 'package:meddashboard/screens/main_screen.dart';
import 'package:meddashboard/screens/notifications_screen.dart';
import 'package:meddashboard/screens/patient_add.dart';
import 'package:meddashboard/screens/profile_settings.dart';
import 'package:meddashboard/models/card.dart';
import 'package:meddashboard/service/models/HeartStateLiveModel.dart';
import 'package:meddashboard/service/models/group_model.dart';
import 'package:meddashboard/service/models/patient_model.dart';
import 'package:meddashboard/utils/app_preference.dart';
import '../main.dart';

class GroupFragment extends StatelessWidget {

  final GroupDataModel group;
  final Function(GroupDataModel val) setPatients;
  List<GroupDataModel> groupList = [];
  List<HeartStateLiveModel> alertList = [];

  GroupFragment(this.group, this.setPatients, this.groupList,
      {this.alertList}) {
    GroupFragment.groupId = group.id;
    GroupFragment.hospitalid = group.hospitalId;
  }

  static String hospitalid = "";
  static String groupId = "";

  static getPatient() {
    List<PatientModel> arr = [];
    List<CardModel> arrr = [];

    MainScreen.allPatients.forEach((element) {
      if (element.patient.group_id == groupId) {
        arr.add(element.patient);
        arrr.add(
          CardModel(
            element.patient,
            battery: 20,
            devices: element.patient.devices,
            pinned: element.patient.pinned ?? false,
          ),
        );
      }
    });
    PatientDataStreamBloc.addPatient(data: arr);
    // await ApiPatient.getPatientByGroup(groupId, hospitalid);

    PatientDataStreamBloc.selectedGroupPatient(
      data: arrr,
    );
  }

  final List<CardModel> models = [];

  @override
  Widget build(BuildContext context) {
    //rebuildAllChildren(context);
    int sspLength = 0;
    getPatient();
    return StreamBuilder(
        stream: PatientDataStreamBloc.patientDataListStream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List<PatientModel> sspd = snapshot.data;
            if (sspd != null) {
              sspLength = sspd.length;
            } else {
              sspd = [];
            }
            List<CardModel> cardList2 = [];
            for (int i = 0; i < sspd.length; i++) {
              cardList2.add(
                CardModel(
                  sspd[i],
                  battery: i * 20,
                  devices: sspd[i].devices,
                  pinned: sspd[i].pinned ?? false,
                ),
              );
            }

            String stringValue = sspLength.toString() + ' patients';

            return ListView(
              padding: const EdgeInsets.all(18.0),
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        MdiIcons.close,
                        color: Style.darkBlue,
                        size: 20,
                      ),
                      onPressed: () => setPatients(null),
                    ),
                    Text(
                      group.groupName,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        color: Style.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 24),
                    Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Style.linkBlue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      stringValue,
                      style: GoogleFonts.firaMono(
                          color: Style.linkBlue, fontSize: 18),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => NotificationScreen());
                      },
                      icon: Icon(
                        MdiIcons.bell,
                        color: Style.accentBlue,
                        size: 26,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    PopupMenuButton(
                      icon: Icon(
                        MdiIcons.accountCircle,
                        color: Style.accentBlue,
                        size: 28,
                      ),
                      onSelected: (e) {
                        if (e == 'logout') {
                          AppPreference.clear();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SignInScreen()));
                        } else if (e == 'settings') {
                          showDialog(
                              context: context,
                              builder: (ctx) => ProfileSettingsScreen());
                        } else if (e == 'password') {
                          showDialog(
                              context: context,
                              builder: (ctx) => ChangePasswordScreen());
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'password',
                            child: Text('Change password'),
                          ),
                          PopupMenuItem<String>(
                            value: 'settings',
                            child: Text('Settings'),
                          ),
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Logout'),
                          ),
                        ];
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      'Alerts',
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: Style.darkBlue,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 12),
                   /* Text(
                      '(${alertList.length.toString()})',
                      style: GoogleFonts.firaMono(
                          color: Style.linkBlue, fontSize: 18),
                    ),*/

                    Text(
                      '(${alertList.length.toString()})',
                      style: GoogleFonts.firaMono(color: Style.linkBlue, fontSize: 18),
                    ),

                  ],
                ),
                alertList.length != 0
                    ? ListView.builder(
                    itemCount: alertList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return AlertPatient(
                        groupName: alertList[index].groupName,
                        patientName: alertList[index].patName,
                        detail: alertList[index].alertDetails,
                      );
                    })
                    : Text(
                  'No new Alerts',
                  style: GoogleFonts.firaMono(
                    fontSize: 18,
                    color: Style.linkBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      'Patients',
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: Style.darkBlue,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) =>
                                PatientAddScreen(group.id, hospitalid));
                      },
                      icon: Icon(
                        MdiIcons.plus,
                        color: Style.accentBlue,
                        size: 26,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                  ],
                ),

                /*   PatientsGrid(
                  cardList2.isEmpty ? models : cardList2,
                  groupList,
                  hospitalid,
                ),*/
                StreamBuilder(
                  stream:
                      PatientDataStreamBloc.selectedGroupPatientDataListStream,
                  builder: (context, snapshot) {
                    return (snapshot.hasData)
                        ? PatientsGrid(
                            cardList2.isEmpty ? snapshot.data : cardList2,
                            groupList,
                            hospitalid,
                          )
                        : Container();
                  },
                )
              ],
            );
          } else {
            return Container();
          }
        });
  }
}

class AlertPatient extends StatelessWidget {
  final String groupName, patientName,detail;

  AlertPatient({this.groupName, this.patientName, this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Style.purple,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                detail != null ? detail.toString() : '',
                style: GoogleFonts.poppins(
                    color: Style.bgBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ],
          ),
          Text(
            '$groupName - $patientName',
            style: GoogleFonts.poppins(color: Style.lineGray, fontSize: 18),
          )
        ],
      ),
    );
  }
}
