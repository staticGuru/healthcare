import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/bloc/patient_data_stream_bloc.dart';
import 'package:meddashboard/model_views/group_component.dart';
import 'package:meddashboard/screens/group_add.dart';
import 'package:meddashboard/screens/main_screen.dart';
import 'package:meddashboard/service/api/hospitals.dart';
import 'package:meddashboard/service/models/HeartStateLiveModel.dart';
import 'package:meddashboard/service/models/group_model.dart';
import 'package:meddashboard/service/models/hopital_model.dart';
import 'package:meddashboard/service/models/patient_model.dart';


import '../main.dart';

class SideBarLayoutComponent extends StatefulWidget {
  final Function(GroupDataModel) setPatients;
  final List<GroupDataModel> list;
  List<HeartStateLiveModel> alertList = [];


  SideBarLayoutComponent(this.setPatients, this.list, {this.alertList});

  @override
  _SideBarLayoutComponentState createState() => _SideBarLayoutComponentState();
}

class _SideBarLayoutComponentState extends State<SideBarLayoutComponent> {

  String searchQ;

  List<HospitalModel> hospitalList = [];

  getHospital() async {
    hospitalList = await APIHospitals.getHospitals();
  }

  List<HeartStateLiveModel> alertList = [];



  @override
  void initState() {
    print('siderbar alertlist-----' + widget.alertList.length.toString());
    getHospital();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    List<GroupDataModel> list = [];
    List<PatientModel> list2 = [];

    for (var el in widget.list) {
      if (searchQ != null && searchQ.isNotEmpty) {
        if (el.groupName.toLowerCase().contains(searchQ.toLowerCase())) {
          list.add(el);
        }
      } else {
        list.add(el);
      }
    }
    if (MainScreen.allPatients.isNotEmpty) {
      for (var el in MainScreen.allPatients) {
        if (searchQ != null && searchQ.isNotEmpty) {
          if (el.patient.patient_name.toLowerCase().contains(searchQ.toLowerCase())) {
            list2.add(el.patient);
          }
        }
      }
    }

    PatientDataStreamBloc.addPatient(data: list2);

    if (w > 1280) {
      return Container(
        width: 350,
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.all(18.0),
            children: [
              Row(
                children: [
                  Icon(
                    MdiIcons.menu,
                    size: 32,
                    color: Style.darkBlue,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Groups',
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
                        builder: (ctx) => GroupAddScreen(hospitalList),
                      );
                    },
                    icon: Icon(
                      MdiIcons.plus,
                      size: 32,
                      color: Style.linkBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Style.accentBlue,
                    borderRadius: BorderRadius.circular(14)),
                child: TextField(
                  onChanged: (str) => setState(() => searchQ = str),
                  cursorColor: Style.bgBlue,
                  style: GoogleFonts.firaMono(color: Style.bgBlue),
                  decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: GoogleFonts.firaMono(
                          color: Style.grayBlue.withOpacity(0.8)),
                      border: InputBorder.none,
                      icon: Icon(
                        MdiIcons.magnify,
                        color: Style.bgBlue,
                      )),
                ),
              ),
              SizedBox(
                height: 8,
              ),
               GroupTile(list,false),
             /* for (final el in list)
                GroupComponent(
                  false,
                  widget.setPatients,
                  el,
                  alertList: alertList,
                ),*/
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
          width: 102,
          child: ListView(padding: EdgeInsets.all(18.0), children: [
            Icon(
              MdiIcons.menu,
              size: 32,
              color: Style.darkBlue,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Style.accentBlue,
                    borderRadius: BorderRadius.circular(14)),
                child: Icon(
                  MdiIcons.magnify,
                  color: Style.bgBlue,
                )),
            SizedBox(
              height: 8,
            ),
            GroupTile(list,true)
           /* for (final el in list)
              GroupComponent(
                true,
                widget.setPatients,
                el,
                alertList: widget.alertList,
              ),*/
          ]));
    }
  }

   Widget GroupTile(List<GroupDataModel> list, bool bool) {
    List<Widget> _temp = [];

    for (final el in list) {
      var contain = widget.alertList.where((element) => element.groupId == el.id);

      if (contain.isEmpty) {
        _temp.add( GroupComponent(bool, widget.setPatients, el, heartState: false));
      } else {
        _temp.add( GroupComponent(bool, widget.setPatients, el, heartState: true));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: _temp);
  }
}
