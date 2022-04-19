import 'dart:convert';

import 'package:meddashboard/service/api/api.dart';
import 'package:meddashboard/service/models/device_model.dart';

class AddDevice {

  static Future<List<DeviceModel>> getDevice(String patientId) async {

    final json = await APIWithFromData.send(
      'hospital/get_device', {'patient_id': patientId},
    );

    List<DeviceModel> arr = [];

    for (final el in jsonDecode(json)) {
      arr.add(DeviceModel.map2Device(el));
    }
    return arr;
  }

  static Future<DeviceModel> addDevice(DeviceModel device) async {
    final json = await APIWithFromData.send(
      'hospital/addDevice',
      device.toMap(),
    );
    return DeviceModel.json2device(json);
  }
}
