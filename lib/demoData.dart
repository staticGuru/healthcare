import 'dart:convert';
import 'dart:math';
import 'package:meddashboard/models/ecg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'bigData.dart';

Stream<EcgModel> getEcgModel1500() async* {
  const pointsAtATime = 20;

  var array = <double>[];

  for (final point in js) {
    array.add(point['y'] / 1);
  }

  array = array.sublist(0, 1);
  bool shouldStart = false;
  int next;
  int previous;
  int offset = 0;

  var oldArray = <double>[];
  var newArray = <double>[];
  void connectAndListen() async {
    print("Connect and Listen");
    try {
      IO.Socket socket = IO.io('http://65.1.31.6:4000',
          OptionBuilder().setTransports(['websocket']).build());
      socket.connect();

      socket.onConnect((_) {
        print('connect');
      });

      socket.onDisconnect((_) {
        print('disconnect');
      });

      socket.on('data', (data) async {
        try {
          print(array.length);
          if (data != null) {
            var liveData = jsonDecode(data);
            if (liveData["emit_name"] != null &&
                liveData["emit_name"] == "ecg") {
              next = liveData["count"];
              if (next != previous) {
                List<double> patientArray =
                    List<double>.from(liveData["patient_record"]);
                array.addAll(patientArray);
              }
              previous = liveData["count"];
              if (array.length >= 1500) {
                shouldStart = true;
                // for (final point in js) {
                //   array.add(point['y'] / 1);
                // }
                // socket.close();
              }

              // if (array.length >= 5000 && array.length <= 5200) {
              //   shouldStart = true;
              //   socket.close();
              // }
            }
          }
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  connectAndListen();
  while (true) {
    print("Should Start $shouldStart");
    if (shouldStart) {
      print("${array.length}, $offset");

      newArray.addAll(array.getRange(offset, offset + pointsAtATime));

      //print(newArray.length);

      if (newArray.length != 0 && oldArray.isNotEmpty) {
        oldArray = oldArray.getRange(pointsAtATime, oldArray.length).toList();
      }

      yield EcgModel(oldData: oldArray, newData: newArray);

      offset += pointsAtATime;

      if (newArray.length >= 1500) {
        oldArray = newArray;
        newArray = <double>[];
      }

      if (offset >= array.length - 100) {
        //offset = 0;
        shouldStart = false;
        //     print("ARRAY ENDED");
      }

      await Future.delayed(Duration(milliseconds: 1)); // for correcting time
    } else {
      print("SHOULD NOT START");
      await Future.delayed(Duration(milliseconds: 1));
    }
  }

  // while (true) {
  //   newArray.addAll(array.getRange(offset, offset + pointsAtATime));

  //   if (newArray.length != 0 && oldArray.isNotEmpty) {
  //     oldArray = oldArray.getRange(pointsAtATime, oldArray.length).toList();
  //   }

  //   yield EcgModel(oldData: oldArray, newData: newArray);

  //   offset += pointsAtATime;

  //   if (newArray.length >= 1500) {
  //     oldArray = newArray;

  //     newArray = <double>[];
  //   }

  //   if (offset >= 14800) {
  //     offset = 0;
  //   }

  //   await Future.delayed(Duration(milliseconds: 50));
  // }
}
