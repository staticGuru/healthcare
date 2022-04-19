import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meddashboard/screens/getting_started/sign_in.dart';
import 'package:meddashboard/screens/main_screen.dart';
import 'package:meddashboard/utils/StreamSocket.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:meddashboard/service/api/hospitals.dart';
import 'package:meddashboard/service/api/patients.dart';
import 'package:meddashboard/service/api/group.dart';
import 'dart:convert';

// --dart-define=FLUTTER_WEB_USE_SKIA=true
import 'package:http/http.dart' as http;
import 'package:meddashboard/service/models/hopital_model.dart';
import 'package:meddashboard/utils/app_preference.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'SocketUtils/MyHttpOverrides.dart';
import 'bloc/patient_data_stream_bloc.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  //connectAndListen();
  await AppPreference.init();

  String id = await AppPreference.getString("hospitalId");

  runApp(MaterialApp(
    home: id != null
        ? MainScreen(
            HospitalModel(
              hospitalId: id,
            ),
          )
        : SignInScreen(),
    // home: MainScreen(HospitalModel(hospitalId: '5f9289edaf1047062c2f7a56')),
  ));
  //const groupid = '5f9284134880cc0a00a6bf08';
  //const hospidid = '5f9289edaf1047062c2f7a56';

  //final sspd = await (ApiPatient.getpatientbygroup(groupid));
  //final sspd = await (ApiGroup.getallgroup(hospidid));
  //(print(ApiPatient.getpatientbygroup()));
  //print('connecting................');
  //print(await APIHospitals.getHospitals());
  //const name = 'sooraj@gmail.com';
  //const password = 'password';
  //print(await HospitalLogin.hospitallogin(name, password));
  // Sending a POST request
  //const url = 'http://34.93.188.210:5000/hospital/login';
  //const payload = {'username': 'sooraj@gmail.com', 'password': 'password'};
  //final response = await http.post(url, body: payload);
  //print(response.);
}

void connectAndListen() {
  IO.Socket socket = IO.io('http://65.1.31.6:4000',
      OptionBuilder().setTransports(['websocket']).build());

  socket.onConnect((_) {
    print('connect');
    // socket.emit('msg', 'test');
  });

  //When an event recieved from server, data is added to the stream
  socket.on('data', (data) {
    PatientDataStreamBloc.livePatient(data: data);
    // print('---------- ' + data);
  });

  socket.onDisconnect((_) => print('disconnect'));
}

class Style {
  // todo rethink color palette

  static final Color darkBlue = Color(0xFF09425A);
  static final Color linkBlue = Color(0xFF007C92);
  static final Color accentBlue = Color(0xFF009ABB);
  static final Color darkGrayBlue = Color(0xFFAABEC6);
  static final Color grayBlue = Color(0xFFD0D8DA);
  static final Color bgBlue = Color(0xFFF0F4F5);

  static final Color maroon = Color(0xFF5E3032);
  static final Color purple = Color(0xFF53284F);
  static final Color orange = Color(0xFFB96D12);
  static final Color darkGreen = Color(0xFF556222);
  static final Color brightGreen = Color(0xFF80982A);
  static final Color lightGreen = Color(0xFFC7D1C6);

  static final Color black = Color(0xFF000000);
  static final Color white = Color(0xFFFFFFFF);
  static final Color textGray = Color(0xFF333333);
  static final Color medGray = Color(0xFF666666);
  static final Color gray = Color(0xFF999999);
  static final Color lightGray = Color(0xFFCCCCCC);
  static final Color lineGray = Color(0xFFDDDDDD);
}
