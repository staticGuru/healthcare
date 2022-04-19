import 'dart:async';
import 'dart:convert';
import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/bloc/patient_data_stream_bloc.dart';
import 'package:meddashboard/fragments/group.dart';
import 'package:meddashboard/models/ECGLive.dart';
import 'package:meddashboard/models/card.dart';
import 'package:meddashboard/screens/main_screen.dart';
import 'package:meddashboard/service/models/BatteryLiveModel.dart';
import 'package:meddashboard/service/models/ECGLiveModel.dart';
import 'package:meddashboard/service/models/HeartRateLiveModel.dart';
import 'package:meddashboard/service/models/HeartStateLiveModel.dart';
import 'package:meddashboard/service/models/ResponseRateLiveModel.dart';
import 'package:meddashboard/service/models/SPO2LiveModel.dart';
import 'package:meddashboard/service/models/SocketEmitModel.dart';
import 'package:meddashboard/service/models/TemperatureLiveModel.dart';
import 'package:meddashboard/models/ecg.dart';
import 'package:meddashboard/screens/add_device.dart';
import 'package:meddashboard/screens/history.dart';
import 'package:meddashboard/screens/patient_settings.dart';
import 'package:meddashboard/service/models/group_model.dart';
import 'package:meddashboard/utils/app_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import '../SocketUtils/SocketEmitName.dart';
import '../components/ecg.dart';
import '../main.dart';
import '../service/api/patients.dart';
import 'package:meddashboard/service/api/spo2.dart';

class CardComponent extends StatefulWidget {
  final CardModel model;
  final List<GroupDataModel> groupList;
  final String hospitalId;
  final String data;

  CardComponent(this.model, this.groupList, this.hospitalId, {this.data});

  @override
  _CardComponentState createState() => _CardComponentState();
}

class _CardComponentState extends State<CardComponent> {
  EcgModelLive ecgModel;
  final StreamController<List<double>> ecg = StreamController.broadcast();
  Widget button(IconData icon, Function onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Material(
        color: Style.textGray,
        shape: CircleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(90),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: Style.bgBlue,
              size: 16,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

//  List<DeviceModel> device = [];

  List<double> traceSine = [];
  List<double> traceCosine = [];
  List<dynamic> arr = [];
  List<double> intList = [];
  List<double> daylist = [];
  List<double> nightlist = [];
  int temp = 0;
  IO.Socket socket;
  Timer timer;
  String dataid;
  void setNormalData() {
    MainScreen.pinedPatients.forEach((element) {
      if (element.patient.id == widget.model.patient.id)
        widget.model.patient.pinned = true;
    });
  }

  getdbid() async {
    final ssid =
        await ApiSpo2.getspo2val(widget.model.patient.devices[0].deviceId);

    final arr = [];
    final date = [];
    for (final ii in ssid) {
      arr.add(ii.databaseid);
      final ele = ii.databaseid.split(' ')[0];
      if (date.contains(ele)) {
        null;
      } else {
        date.add(ele);
      }
    }

    dataid = arr[arr.length - 1];
    return [arr, date];
  }

  getspo2() async {
    final datetimearry = dataid.split(' ');

    final ssid = await ApiSpo2.getfullspo2date(
        widget.model.patient.devices[0].deviceId, datetimearry[0]);

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

  Future setLiveData() async {
    setNormalData();

    String id = await AppPreference.getString("hospitalId");
    final databaseid = await getdbid();
    socket = IO.io(SocketEmitName.socketURL,
        OptionBuilder().setTransports(['websocket']).build());

    socket.connect();

    print('check hospital id ' +
        id +
        ' patient id ----' +
        widget.model.patient.id +
        ' patient name---' +
        widget.model.name +
        ' device' +
        widget.model.patient.devices[0].deviceId);

    socket.on(SocketEmitName.data, (data) {
      final liveData = jsonDecode(data);

      SocketEmitModel checkType = SocketEmitModel.fromJson(liveData);

      switch (checkType.emitName) {
        case SocketEmitName.battery:
          // print('socket received emit name--->' + SocketEmitName.battery);

          BatteryLiveData battery = BatteryLiveData.fromJson(liveData);

          var contain = widget.model.patient.devices
              .where((element) => element.deviceId == battery.deviceId);

          if (contain.isNotEmpty) {
            for (int i = 0; i < widget.model.patient.devices.length; i++) {
              if (widget.model.patient.devices[i].deviceId ==
                  battery.deviceId) {
                if (mounted) {
                  setState(() {
                    widget.model.patient.devices[i].battery =
                        battery.patientRecord;
                  });
                }
              }
            }
          }

          break;

        case SocketEmitName.temp:
          // print('socket received emit name--->' + SocketEmitName.temp);
          TemperatureLiveModel temperature =
              TemperatureLiveModel.fromJson(liveData);

          var contain = widget.model.patient.devices
              .where((element) => element.deviceId == temperature.deviceId);

          if (contain.isNotEmpty) {
            if (mounted) {
              setState(() {
                widget.model.temperature = temperature.patientRecord.toString();
                widget.model.patient.temp =
                    temperature.patientRecord.toString();
              });
            }
          }

          break;

        case SocketEmitName.spo2:
          //print('socket received emitt name--->' + SocketEmitName.spo2);

          SPO2LiveModel spo2 = SPO2LiveModel.fromJson(liveData);

          var contain = widget.model.patient.devices
              .where((element) => element.deviceId == spo2.deviceId);

          if (contain.isNotEmpty) {
            setState(() {
              widget.model.o2 = spo2.patientRecord.toString();
              widget.model.patient.spo2 = spo2.patientRecord.toString();
            });
          }

          break;

        case SocketEmitName.ecg:
          //  print('socket received emit name--->' + SocketEmitName.ecg);

          ECGLiveModel ecgLiveModel = ECGLiveModel.fromJson(liveData);

          var contain = widget.model.patient.devices
              .where((element) => element.deviceId == ecgLiveModel.deviceId);
          if (contain.isNotEmpty) {
            if (ecgLiveModel.patientRecord.isNotEmpty) {
              traceSine = widget.model.patient.ecgData;

              if (traceCosine.length >= 500) {
                //print("removed");
                //  traceCosine.removeRange(0, 150);
                traceCosine.addAll(ecgLiveModel.patientRecord);
              } else {
                traceCosine.addAll(ecgLiveModel.patientRecord);
              }
              widget.model.patient.ecgData = traceCosine;
              // EcgModelLive ecgModel = new EcgModelLive(newData: traceCosine);

              ecg.add(widget.model.patient.ecgData);
            }
          }
          break;

        case SocketEmitName.heart_rate:
          //  print('socket received emit name--->' + SocketEmitName.heart_rate);

          HeartRateLiveModel heartLiveModel =
              HeartRateLiveModel.fromJson(liveData);

          var contain = widget.model.patient.devices
              .where((element) => element.deviceId == heartLiveModel.deviceId);

          if (contain.isNotEmpty) {
            setState(() {
              widget.model.patient.heart =
                  heartLiveModel.patientRecord.toString();
            });
          }

          break;

        case SocketEmitName.resp_rate:
          //  print('socket received emit name--->' + SocketEmitName.resp_rate);
          ResponseRateLiveModel responseRateLiveModel =
              ResponseRateLiveModel.fromJson(liveData);

          var contain = widget.model.patient.devices.where(
              (element) => element.deviceId == responseRateLiveModel.deviceId);

          if (contain.isNotEmpty) {
            setState(() {
              widget.model.patient.lungs =
                  responseRateLiveModel.patientRecord.toString();
            });
          }

          break;

        case SocketEmitName.state:
          //  print('socket received emit name--->' + data);

          HeartStateLiveModel responseRateLiveModel =
              HeartStateLiveModel.fromJson(liveData);

          if (widget.model.patient.id == responseRateLiveModel.patientId) {
            setState(() {
              widget.model.patient.heartState =
                  responseRateLiveModel.patientRecord.toString();
            });
          }

          break;

        case SocketEmitName.alert:
          //  print('socket received emit name--->' + data);

          HeartStateLiveModel responseRateLiveModel =
              HeartStateLiveModel.fromJson(liveData);

          if (widget.model.patient.id == responseRateLiveModel.patientId) {
            setState(() {
              if (responseRateLiveModel.patientRecord != 'Normal') {
                widget.model.patient.alert = true;
              } else {
                widget.model.patient.alert = false;
              }
            });
          }

          break;

        default:
          break;
      }
    });

    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  void didUpdateWidget(CardComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    setLiveData();
  }

  double radians = 0.0;

  /*_generateTrace(Timer t) {
    // generate our  values
    var sv = sin((radians * pi));
    var cv = cos((radians * pi));

    // Add to the growing dataset
    setState(() {
      //traceSine.add(sv);
      traceCosine.add(cv);
      String json = jsonEncode(traceCosine);
    });

    // adjust to recyle the radian value ( as 0 = 2Pi RADS)
    radians += 0.05;

    if (radians >= 2.0) {
      radians = 0.0;
    }
  }*/

  @override
  void dispose() {
    super.dispose();
    socket?.dispose();
    ecg?.close();
    timer?.cancel();
  }

  @override
  void initState() {
    // getDeviceData();
    super.initState();

    // setLiveData();
  }

  @override
  Widget build(BuildContext context) {
    int length = widget.model.patient.devices.length < 3
        ? widget.model.patient.devices.length
        : 3;

    // Oscilloscope ecgGraph = Oscilloscope(
    //   showYAxis: false,
    //   backgroundColor: Style.darkBlue,
    //   traceColor: Colors.white,
    //   yAxisMax: 0.0007,
    //   yAxisMin: -0.0007,
    //   dataSet: widget.model.patient.ecgData,
    // );

    return Container(
      margin: EdgeInsets.all(4),
      width: 445,
      height: 200,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        // color: widget.model.bad ? Style.orange : Style.linkBlue,
        color: widget.model.patient.alert ? Style.orange : Style.linkBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 28.0),
                  text: TextSpan(
                      style: GoogleFonts.poppins(
                          color: Style.bgBlue, fontSize: 28),
                      text: widget.model.name),
                ),
              ),
              /*   Expanded(
                child: Text(
                  '123456755',
                  style: GoogleFonts.poppins(color: Style.bgBlue, fontSize: 28),
                  overflow: TextOverflow.ellipsis,
                ),
              ),*/
              SizedBox(
                width: 5,
              ),
              Text(
                widget.model.age.toString(),
                style: GoogleFonts.poppins(color: Style.grayBlue, fontSize: 24),
              ),
              Spacer(),
              if (widget.model.patient.devices.length < 3)
                IconButton(
                  icon: Icon(
                    MdiIcons.plus,
                    color: Style.grayBlue,
                    size: 24,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => DeviceScreen(
                        widget.model.patientId,
                        ctx,
                        widget.hospitalId,
                      ),
                    ).then((value) => setState(() {
                          // getDeviceData();
                        }));
                  },
                ),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < length; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            BatteryIndicator(
                              style: BatteryIndicatorStyle.skeumorphism,
                              batteryLevel: widget.model.patient.devices != null
                                  ? int.parse(
                                      widget.model.patient.devices[i].battery)
                                  : 0,
                              /* batteryLevel: 0,*/
                              mainColor: Style.white,
                              percentNumSize: 12,
                              ratio: 2.5,
                              colorful: false,
                              showPercentNum: false,
                              showPercentSlide: true,
                              batteryFromPhone: false,
                            ),
                            SizedBox(height: 2),
                            Text(
                              (widget.model.patient.devices[i].deviceType ==
                                      "1")
                                  ? "ECG"
                                  : "PPG",
                              style: GoogleFonts.firaMono(
                                color: Style.bgBlue,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      )
                  ]),
              SizedBox(
                width: 8,
              ),
              Material(
                color: Style.textGray,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'history',
                      style: GoogleFonts.firaMono(
                        color: Style.bgBlue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final dataid = await getdbid();
                    List<dynamic> spo2data = await getspo2();

                    showDialog(
                      context: context,
                      builder: (ctx) =>
                          HistoryScreen(widget.model, dataid, spo2data),
                    );
                  },
                ),
              ),
              button(
                MdiIcons.cog,
                () {
                  showDialog(
                    context: context,
                    builder: (ctx) => PatientSettingsScreen(
                      widget.model,
                      widget.groupList,
                      widget.hospitalId,
                    ),
                  );
                },
              ),
              button(
                widget.model.pinned ? MdiIcons.pinOff : MdiIcons.pin,
                () {
                  setState(() {
                    MainScreen.allPatients.forEach((element) {
                      if (element.patient.id == widget.model.patient.id) {
                        widget.model.pinned = !widget.model.pinned;
                        element.patient.pinned = !element.patient.pinned;
                        (widget.model.pinned)
                            ? MainScreen.pinedPatients.add(widget.model)
                            : MainScreen.pinedPatients.remove(widget.model);
                      }
                    });
                    PatientDataStreamBloc.pinePatient(
                      data: MainScreen.pinedPatients,
                    );
                  });
                },
              ),
              button(
                MdiIcons.delete,
                () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      content: Text("Are you sure to delete patient?"),
                      actions: [
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              print(MainScreen.allPatients.length);
                              ApiPatient.deletePatients(widget.model.patientId);
                              GroupFragment.getPatient();
                              Navigator.pop(context);
                              // MainScreen.allPatients.forEach((element) {
                              //   if (element.patient.id ==
                              //       widget.model.patient.id)
                              //     MainScreen.allPatients.remove(element);
                              // });
                              print(MainScreen.allPatients.length);
                            });
                          },
                          child: Text("Ok"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                width: 6,
              ),
              /*  Material(
                color: Style.textGray,
                shape: CircleBorder(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(90),
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        MdiIcons.cog,
                        color: Style.bgBlue,
                        size: 16,
                      )),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => PatientSettingsScreen());
                  },
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Material(
                color: Style.textGray,
                shape: CircleBorder(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(90),
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        widget.model.pinned ? MdiIcons.pinOff : MdiIcons.pin,
                        color: Style.bgBlue,
                        size: 16,
                      )),
                  onTap: () {
                    setState(() {
                      widget.model.pinned = !widget.model.pinned;
                    });
                    setStateForStatsFragment(() {});
                  },
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Material(
                color: Style.textGray,
                shape: CircleBorder(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(90),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      MdiIcons.delete,
                      color: Style.bgBlue,
                      size: 16,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: Text("Are you sure to delete patient?"),
                        actions: [
                          FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                ApiPatient.deletePatients(
                                  widget.model.patientId,
                                );
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Ok"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),*/
            ],
          ),
          Row(
            children: [
              Text(
                'IP/OP: ${widget.model.patient.ip_op_io_num}',
                style: GoogleFonts.firaMono(
                    color: Style.grayBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Icon(
                MdiIcons.heart,
                color: Style.bgBlue,
                size: 14,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                widget.model.patient.heartState,
                style: GoogleFonts.poppins(color: Style.bgBlue, fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Style.darkBlue,
                    ),
                    child: /*ecgGraph*/
                        StreamBuilder<EcgModel>(
                            stream: widget.model.ecg.stream,
                            builder: (context, snapshot) {
//                          print(snapshot.data);
//                          print('build');
                              if (snapshot.hasData) {
//                            print('n null');
                                return CustomPaint(
                                  size: Size(100, 100),
                                  painter: EcgPainter(snapshot.data),
                                );
                              } else {
//                            print('null @!');
                                return Container();
                              }
                            }),
                    /*ecgModel != null
                        ? CustomPaint(
                            size: MediaQuery.of(context).size,
                            painter: EcgPainter(ecgModel),
                          )
                        : Container()*/
                    /*StreamBuilder<EcgModel>(
                        stream: widget.model.ecgData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CustomPaint(
                              size: MediaQuery.of(context).size,
                              painter: EcgPainter(snapshot.data),
                            );
                          } else {
                            return Container();
                          }
                        })*/
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      _VitalCard(
                        null,
                        '${widget.model.patient.heart} BPM',
                        svg: 'heart.png',
                      ),
                      // _VitalCard(MdiIcons.heart, widget.model.heart.toString()),
                      SizedBox(
                        height: 6,
                      ),
                      _VitalCard(
                        null,
                        '${widget.model.patient.spo2} %',
                        svg: 'oxygen.png',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      _VitalCard(
                        null,
                        '${widget.model.patient.lungs} RR',
                        svg: 'lungs.png',
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      _VitalCard(
                        null,
                        '${widget.model.patient.temp} °C',
//                        bad: bad,
                        svg: 'temperature.png',
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool bad;
  final String svg;

  _VitalCard(this.icon, this.text, {this.bad = false, this.svg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bad ? Style.black : Style.darkBlue,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 2,
            ),
            SizedBox(
              width: 26,
              child: svg == null
                  ? Icon(
                      icon,
                      color: Style.grayBlue,
                    )
                  : Image.asset(
                      'assets/icons/$svg',
                      height: 16,
                      color: Style.grayBlue,
                    ),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.firaMono(color: Style.bgBlue, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
