import 'dart:html';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/components/ecg.dart';
import 'package:meddashboard/components/spo2.dart';
import 'package:meddashboard/models/ecg.dart';
import 'package:meddashboard/models/history_chart.dart';
import 'package:meddashboard/models/spo2.dart';
import 'package:meddashboard/service/models/spo2temp_model.dart';
import 'package:provider/provider.dart';
import 'package:meddashboard/service/api/spo2.dart';
import '../bigData.dart';
import '../main.dart';

class HistoryScreen extends StatefulWidget {
  final patient_id;
  final dataid;
  List<dynamic> spo2;
  HistoryScreen(this.patient_id, this.dataid, this.spo2);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();

  List<String> times = [];
}

class _HistoryScreenState extends State<HistoryScreen> {
  int selected = 0;

  final scrollList = ScrollController();
  final scrollBig = ScrollController();
  int time = 1;
  List<bool> isSelected = [true, false, false, false, false];
  List<double> maingraph = [];
  List<double> daymain = [];
  List<double> nightmain = [];
  List<dynamic> sd;
  String newtime = null;
  List<double> spo21;
  String dateid;
  HistoryChartInteractionModel providerModel;
  List<dynamic> arr = [];
  List<double> intList = [];
  List<double> daylist = [];
  List<double> nightlist = [];
  int initstate = 0;
  int select = 0;
  int index = 0;
  //String dateid = dataid[0];
  void initState() {
    if (initstate == 0) {
      dateid = widget.dataid[1][widget.dataid[1].length - 1];
      sd = widget.spo2;
      print('jjjjjjjjjjjjjjjjjjjjjjjjjjjj');
      print(sd);
      maingraph = spo21;
      initstate = 1;
    }
  }

  getspo2() async {
    final ssid = await ApiSpo2.getfullspo2val('100053', '2021-05-25 05:13:59');
    intList = [];
    for (var ii in ssid) {
      arr = ii.spo2;
    }
    for (var pp in arr) {
      var myDouble = double.parse(pp);
      assert(myDouble is double);
      intList.add(myDouble);
    }

    //List<double> intList = listDouble.map((s) => s as double).toList();
    return intList;
  }

  getspo2bydate(userid, dateid) async {
    final ssid = await ApiSpo2.getfullspo2date(userid, dateid);
    daylist = [];
    nightlist = [];
    arr = [];
    List<dynamic> daydata = [];
    List<dynamic> nightdata = [];
    for (var ii in ssid) {
      var lip = ii.spo2;

      final datetimearry = ii.databaseid.split(' ');
      final timecheck = int.parse(datetimearry[1].split(':')[0]);

      if (timecheck >= 6 && timecheck <= 18) {
        for (var pp in lip) {
          //arr = ii.spo2;
          daydata.add(pp);
        }
      } else {
        for (var pp in lip) {
          //arr = ii.spo2;
          nightdata.add(pp);
        }
      }
    }
    for (var pp in daydata) {
      var myDouble = double.parse(pp);
      assert(myDouble is double);
      daylist.add(myDouble);
    }

    for (var pp in nightdata) {
      var myDouble = double.parse(pp);
      assert(myDouble is double);
      nightlist.add(myDouble);
    }

    //List<double> intList = listDouble.map((s) => s as double).toList();

    return [daylist, nightlist];
  }

  gettempbydate(userid, dateid) async {
    final ssid = await ApiSpo2.getfullspo2date(userid, dateid);
    daylist = [];
    nightlist = [];
    arr = [];
    List<dynamic> daydata = [];
    List<dynamic> nightdata = [];
    for (var ii in ssid) {
      var lip = ii.temp;

      final datetimearry = ii.databaseid.split(' ');
      final timecheck = int.parse(datetimearry[1].split(':')[0]);

      if (timecheck >= 6 && timecheck <= 18) {
        for (var pp in lip) {
          //arr = ii.spo2;
          daydata.add(pp);
        }
      } else {
        for (var pp in lip) {
          //arr = ii.spo2;
          nightdata.add(pp);
        }
      }
    }
    for (var pp in daydata) {
      var myDouble = double.parse(pp);
      assert(myDouble is double);
      daylist.add(myDouble);
    }

    for (var pp in nightdata) {
      var myDouble = double.parse(pp);
      assert(myDouble is double);
      nightlist.add(myDouble);
    }

    //List<double> intList = listDouble.map((s) => s as double).toList();

    return [daylist, nightlist];
  }

  gettemp() async {
    final ssid = await ApiSpo2.getfullspo2val('100053', '2021-05-25 05:13:59');

    for (var ii in ssid) {
      arr = ii.temp;
    }
    for (var pp in arr) {
      var myDouble = double.parse(pp);
      assert(myDouble is double);
      intList.add(myDouble);
    }

    //List<double> intList = listDouble.map((s) => s as double).toList();
    return intList;
  }

  @override
  Widget build(BuildContext context) {
    double width = 0;
    String userids = widget.patient_id.patient.devices[0].deviceId;
    initState();
    final dataids = widget.dataid[0];
    final date = widget.dataid[1];

    print(date);
    //spo21 = widget.spo2;

    widget.times = [];
    for (final ii in dataids) {
      if (ii.contains(date[date.length - 1])) {
        widget.times.add(ii.split(' ')[1]);
      }
    }

    scrollBig.addListener(() async {
      providerModel.offsetFromBig = scrollBig.offset / 10000;
      //final databaseid = await getdbid();

//      print(width * 15000 / 10000);
//      setState(() {
//        offset1 = (scrollBig.offset / 10000);        borderRadius: BorderRadius.circular(12),

//        offset2 = ((scrollBig.offset + width) / 10000);
//      });

//      print('l: ' +
//          scrollBig.offset.toString() +
//          ' ' +
//          width.toString() +
//          ' |||| ' +
//          (scrollBig.offset / 10000).toString() +
//          ' | ' +
//          ((scrollBig.offset + width) / 10000).toString());
    });

    return Center(
      child: Padding(
          padding: EdgeInsets.all(36),
          child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'History',
                          style: GoogleFonts.poppins(
                              color: Style.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          widget.patient_id.name,
                          style: GoogleFonts.poppins(
                              color: Style.darkBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.patient_id.patient.ip_op_io_num,
                          style: GoogleFonts.poppins(
                              color: Style.linkBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 36,
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(12),
                            children: <Widget>[
                              Text('SpO2'),
                              Text('Temp'),
                              Text('RR'),
                              Text('PR'),
                              Text('ECG'),
                            ],
                            onPressed: (index) async {
                              if (index == 0) {
                                sd = await getspo2bydate(userids, dateid);
                                print('sp.................;');
                                print(sd);
                                maingraph = sd[0];
                              }

                              if (index == 1) {
                                sd = await gettempbydate(userids, dateid);
                                print('sp.................;');
                                print(sd);
                                maingraph = sd[0];
                              }

                              print('ssssssssssssssssss');
                              print(index);
                              //SisSelected[index] = !isSelected[index];
                              setState(() {
                                spo21 = maingraph;
                                isSelected = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                                isSelected[index] = !isSelected[index];
                                print(isSelected);
                              });
                            },
                            isSelected: isSelected,
                          ),
                        ),
                        SizedBox(
                          width: 22,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(MdiIcons.close)),
                      ],
                    ),
                    Row(children: [
                      DropdownButton(
                        icon: Icon(MdiIcons.menuDown),
                        value: dateid,
                        onChanged: (val) async {
                          if (index == 0) {
                            sd = await getspo2bydate(userids, val);

                            maingraph = sd[0];
                          }
                          if (index == 1) {
                            sd = await gettempbydate(userids, val);

                            maingraph = sd[0];
                          }
                          setState(() {
                            dateid = val;
                            spo21 = maingraph;
                          });
                        },
                        items: [
                          for (int i = 0; i < date.length; i++)
                            DropdownMenuItem(
                              child: Text(date[i]),
                              value: date[i],
                            ),
                        ],
                      ),
                    ]),
                    Container(
                      height: 314, // 260+54
                      decoration: BoxDecoration(
                          color: Style.darkBlue,
                          borderRadius: BorderRadius.circular(12)),
                      child: LayoutBuilder(
                        builder: (ctx, sizes) {
                          width = sizes.maxWidth;

                          if (providerModel == null) {
                            providerModel = HistoryChartInteractionModel(width);
                            providerModel.addListener(() {
                              if (providerModel.lastUpdate ==
                                  HistoryChartType.big) return;
                              scrollBig.jumpTo(providerModel.offset * 10000);
                            });
                          }

//                          print(width / 10000 * 15000);
//                          print('n');
//                          print(width);
//                          print('w');
//
//                          print(width / 10000 * width);

                          List<double> list = [];

                          for (final point in js) {
                            list.add(point['y'] / 1);
                          }
                          list = sd[select];
                          print('...............................');
                          print(list);
                          dynamic painter;
                          dynamic model;
                          if (select == 4) {
                            model = EcgModel(newData: list, oldData: []);
                            painter = EcgPainter(model);
                          } else {
                            model = Spo2tempModel(newData: list, oldData: []);
                            painter = Spo2Painter(model);
                          }

                          model.length = list.length;
                          return Column(
                            children: [
                              SingleChildScrollView(
                                controller: scrollBig,
                                scrollDirection: Axis.horizontal,
                                child: CustomPaint(
                                  size: Size(10000, sizes.maxHeight - 54),
                                  painter: painter,
                                ),
                              ),
                              Spacer(),
                              strip(providerModel),
                            ],
                          );
//                          return Container();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // Container(
                    //   color: Style.linkBlue,
                    //   height: 2,
                    //   width: double.infinity,
                    // ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    Expanded(
                      child: DraggableScrollbar.rrect(
//                        labelTextBuilder: (double offset) =>
//                            Text("${offset ~/ 60}"),
                        controller: scrollList,
                        child: ListView.builder(
                          controller: scrollList,
//                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (ctx, index) => ordinaryStrip(index),
                        ),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }

  Widget ordinaryStrip(int id) {
    select = id;
    print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkddddd');
    print(id);
    final body = Material(
      color: Style.darkBlue,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          scrollBig.jumpTo(0);

          setState(() {
            selected = id;
          });
        },
        child: Container(
          height: 64,
//            decoration: BoxDecoration(
//                color: Style.darkBlue, borderRadius: BorderRadius.circular(12)),
          child: LayoutBuilder(
            builder: (ctx, sizes) {
              List<double> list = [];

              for (final point in js) {
                list.add(point['y'] / 1);
              }

              list = sd[0];
              if (id == 1) {
                list = sd[1];
                select = 1;
              }

              if (id == 0) {
                list = sd[0];
                select = 0;
              }

              print('ffffffffffffffffffffffffffffffffffffffff');
              print(spo21);

              dynamic painter;
              dynamic model;
              if (select == 4) {
                model = EcgModel(newData: list, oldData: []);
                painter = EcgPainter(model);
              } else {
                model = Spo2tempModel(newData: list, oldData: []);
                painter = Spo2Painter(model);
              }

              model.length = list.length;
              return CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
                painter: painter,
              );
            },
          ),
        ),
      ),
    );

    final display = id == selected
        ? Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Stack(
              children: [
                body,
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(MdiIcons.check, color: Colors.white),
                  ),
                ))
              ],
            ),
          )
        : Padding(padding: EdgeInsets.only(bottom: 10), child: body);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${id == 0 ? 'day' : 'night'}',
          style: TextStyle(fontSize: 14, color: Style.darkBlue),
        ),
        SizedBox(height: 4),
        display
      ],
    );
  }

  Widget strip(HistoryChartInteractionModel providerModel) => Container(
      height: 54,
//      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Style.linkBlue, borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (ctx, sizes) {
          List<double> list = [];

          for (final point in js) {
            list.add(point['y'] / 1);
          }
          list = sd[selected];
          GlobalKey _paintKey = new GlobalKey();
          dynamic painter;
          dynamic model;
          if (select == 4) {
            model = EcgModel(newData: list, oldData: []);
            painter = EcgPainter(model);
          } else {
            model = Spo2tempModel(newData: list, oldData: []);
            painter = Spo2Painter(model);
          }

          //final model = EcgModel(newData: list, oldData: []);
          model.length = list.length;
          return Listener(
            onPointerUp: (PointerUpEvent event) {
              RenderBox referenceBox =
                  _paintKey.currentContext.findRenderObject();
              Offset offset = referenceBox.globalToLocal(event.position);
//                    print(offset.dx / providerModel.width);

              providerModel.widthDrag = 0;

              if (!providerModel.drag)
                providerModel.offsetFromStrip =
                    (offset.dx - providerModel.stripWidth / 2) /
                        providerModel.width;

//                    print('click');
//                    setState(() => click = offset.dx);
            },
            onPointerDown: (PointerDownEvent event) {
              RenderBox referenceBox =
                  _paintKey.currentContext.findRenderObject();
              Offset offset = referenceBox.globalToLocal(event.position);
              providerModel.drag = false;

              providerModel.widthDrag =
                  offset.dx - providerModel.width * providerModel.offset;
            },
            onPointerMove: (PointerMoveEvent event) {
              RenderBox referenceBox =
                  _paintKey.currentContext.findRenderObject();
              Offset offset = referenceBox.globalToLocal(event.position);
              providerModel.drag = true;
              providerModel.offsetFromStrip =
                  (offset.dx - providerModel.widthDrag) / providerModel.width;
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  CustomPaint(
                    key: _paintKey,
                    size: Size(sizes.maxWidth, sizes.maxHeight),
                    painter: painter,
                  ),
                  ChangeNotifierProvider.value(
                      value: providerModel,
                      child: Consumer<HistoryChartInteractionModel>(
                        builder: (context, cart, child) {
                          return Positioned.fromRect(
                              rect: Rect.fromPoints(
                                  Offset(
                                      providerModel.width *
                                          providerModel.offset,
                                      0),
                                  Offset(
                                      providerModel.width *
                                              providerModel.offset +
                                          providerModel.stripWidth,
                                      72)),
                              child: child);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Style.maroon.withOpacity(0.6),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        },
      ));
}
