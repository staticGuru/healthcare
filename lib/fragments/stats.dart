import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/bloc/patient_data_stream_bloc.dart';
import 'package:meddashboard/components/patients_grid.dart';
import 'package:meddashboard/model_views/stat_component.dart';
import 'package:meddashboard/screens/change_password.dart';
import 'package:meddashboard/screens/getting_started/sign_in.dart';
import 'package:meddashboard/screens/notifications_screen.dart';
import 'package:meddashboard/screens/profile_settings.dart';
import 'package:meddashboard/service/models/HeartStateLiveModel.dart';
import 'package:meddashboard/service/models/group_model.dart';
import '../main.dart';

class StatsFragment extends StatefulWidget {
  final List<GroupDataModel> groupList;
  final String hospitalId;
  final List<HeartStateLiveModel> alertList;

  StatsFragment({this.groupList, this.hospitalId, this.alertList});

  @override
  _StatsFragmentState createState() => _StatsFragmentState();
}

class _StatsFragmentState extends State<StatsFragment> {
  Timer timer;

  checkNewCount() {
    PatientDataStreamBloc.statsCount();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => checkNewCount());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18.0),
      children: [
        Row(
          children: [
            Text(
              'Stats',
              style: GoogleFonts.poppins(
                  fontSize: 28,
                  color: Style.darkBlue,
                  fontWeight: FontWeight.w600),
            ),
            // SizedBox(width: 24),
            // Container(
            //   height: 12,
            //   width: 12,
            //   decoration:
            //       BoxDecoration(shape: BoxShape.circle, color: Style.linkBlue),
            // ),
            // SizedBox(width: 8),
            // Text(
            //   'All systems operational',
            //   style: GoogleFonts.firaMono(color: Style.linkBlue, fontSize: 18),
            // ),
            Spacer(),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (ctx) => NotificationScreen());
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => SignInScreen()));
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
        Visibility(
          visible: false,
          child: StreamBuilder(
              stream: PatientDataStreamBloc.statsCountDataListStream,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    StatComponent(
                      name: 'Connected patients',
                      count: '54',
                    ),
                    SizedBox(
                      width: 36,
                    ),
                    StatComponent(
                      name: 'Active patients',
                      count: '54',
                    ),
                  ],
                );
              }),
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
            Text(
              '(${widget.alertList.length.toString()})',
              style: GoogleFonts.firaMono(color: Style.linkBlue, fontSize: 18),
            ),
          ],
        ),
        widget.alertList.length != 0
            ? ListView.builder(
                itemCount: widget.alertList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AlertPatient(
                    groupName: widget.alertList[index].groupName,
                    patientName: widget.alertList[index].patName,
                    detail: widget.alertList[index].alertDetails,
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
        /*  Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Style.purple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Text(
                    'Suspicious activity',
                    style: GoogleFonts.poppins(
                        color: Style.bgBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
              Text(
                '2A - John Doe',
                style: GoogleFonts.poppins(color: Style.lineGray, fontSize: 18),
              )
            ],
          ),
        ),*/
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Text(
              'Pinned patients',
              style: GoogleFonts.poppins(
                fontSize: 28,
                color: Style.darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
        StreamBuilder(
          stream: PatientDataStreamBloc.pinnedPatientDataListStream,
          builder: (context, snapshot) {
            return (snapshot.hasData)
                ? PatientsGrid(
                    snapshot.data,
                    widget.groupList,
                    widget.hospitalId,
                  )
                : Container();
          },
        )
//        SizedBox(
//          height: 32,
//        ),
//        Text(
//          'select a group of patients on the left side\nto see more information',
//          textAlign: TextAlign.center,
//          style: GoogleFonts.poppins(
//              fontWeight: FontWeight.w500, color: Style.linkBlue, fontSize: 20),
//        )

        // the interesting stuff goes here
//              PatientsGrid()
      ],
    );
  }
}

class AlertPatient extends StatelessWidget {
  final String groupName, patientName, detail;

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
