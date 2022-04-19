import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/SocketUtils/SocketEmitName.dart';
import 'package:meddashboard/main.dart';
import 'package:meddashboard/service/models/HeartStateLiveModel.dart';
import 'package:meddashboard/service/models/SocketEmitModel.dart';
import 'package:meddashboard/service/models/group_model.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class GroupComponent extends StatefulWidget {

  final GroupDataModel model;
  final bool collapsed;
  final bool heartState;
  final Function(GroupDataModel group) onClick;
 final List<HeartStateLiveModel> alertList;

  GroupComponent(this.collapsed, this.onClick, this.model,
      {this.alertList, this.heartState});

  @override
  _GroupComponentState createState() => _GroupComponentState();
}

class _GroupComponentState extends State<GroupComponent> {

  bool hearState = false;
  var widgetdata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widgetdata = widget.collapsed
        ? GroupComponentCollapsed(
            widget.model,
            hearState: false,
          )
        : GroupComponentExpanded(
            widget.model,
            heartState: false,
          );
    getLiveAlert();
    //setData();
  }

  IO.Socket socket;

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

          HeartStateLiveModel responseRateLiveModel = HeartStateLiveModel.fromJson(liveData);

          if (responseRateLiveModel.patientRecord != 'Normal') {
            if (widget.model.id == responseRateLiveModel.groupId) {
              widgetdata = widget.collapsed
                  ? GroupComponentCollapsed(
                      widget.model,
                      hearState: true,
                    )
                  : GroupComponentExpanded(
                      widget.model,
                      heartState: true,
                    );
            }
          } else {
            if (widget.model.id == responseRateLiveModel.groupId) {
              widgetdata = widget.collapsed
                  ? GroupComponentCollapsed(
                      widget.model,
                      hearState: false,
                    )
                  : GroupComponentExpanded(
                      widget.model,
                      heartState: false,
                    );
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
  Widget build(BuildContext context) {
    // var widgetdata = widget.collapsed ? GroupComponentCollapsed(widget.model) : GroupComponentExpanded(widget.model);
    return Stack(
      children: [
        widgetdata,
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  widget.onClick(widget.model);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GroupComponentExpanded extends StatelessWidget {
  final GroupDataModel model;
  final bool heartState;

  GroupComponentExpanded(this.model, {this.heartState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: !model.active ? Style.white : Style.linkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              model.groupName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: !model.active ? Style.textGray : Style.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CircleAvatar(
                    radius: 6.0,
                    backgroundColor:
                        !model.active ? Style.medGray : Style.grayBlue,
                  ),
                ),
                Text(
                  '7 patients',
                  style: TextStyle(
                      color: !model.active ? Style.medGray : Style.grayBlue,
                      fontSize: 14),
                ),*/
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  decoration: BoxDecoration(
                      color: heartState ? Style.orange : Style.lightGreen,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/oxygen.png',
                        width: 16,
                        color: heartState ? Style.white : Style.black,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        model.groupName == '2A' ? '89' : '99',
                        style: GoogleFonts.firaMono(
                            color: heartState ? Style.white : Style.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Icon(
                        MdiIcons.heart,
                        size: 16,
                        color: heartState ? Style.white : Style.black,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        model.groupName == '2A' ? '45' : '73',
                        style: GoogleFonts.firaMono(
                            color: heartState ? Style.white : Style.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GroupComponentCollapsed extends StatelessWidget {
  final GroupDataModel model;
  final bool hearState;

  GroupComponentCollapsed(this.model, {this.hearState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: !model.active ? Style.white : Style.linkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        model.groupName,
        style: GoogleFonts.poppins(
            color: !model.active ? Style.textGray : Style.white,
            fontSize: 24,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
