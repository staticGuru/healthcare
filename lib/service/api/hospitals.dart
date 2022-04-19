import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'package:meddashboard/service/api/api.dart';
import 'package:meddashboard/service/models/hopital_model.dart';

///Hospital apis
//**************************

///api to fetch all hospital details
class APIHospitals {
  static Future<List<HospitalModel>> getHospitals() async {
    final json = jsonDecode(await API.send('hospital/getAllHospitals'));
    var arr = <HospitalModel>[];
    for (final el in json) {
      arr.add(HospitalModel.map2Hospital(el));
    }
    return arr;
  }

  static Future<HospitalModel> getHospitalId(String username) async {
    final json = jsonDecode(
      await APIWithFromData.send(
        'hospital/getHospitalid',
        {'username': username},
      ),
    );
    HospitalModel arr = HospitalModel.map2Hospital(json);

    return arr;
  }
}

/// api to check hospital login details
class HospitalLogin {
  static hospitallogin(name, password) async {
    final payload = {'username': name, 'password': password};
    final data = jsonEncode(payload);

    final json = jsonDecode(await APII.send('hospital/login', data));
    return json;
  }
}

/// api to register new hospital details
class HospitalSignUp {
  static Future hospitalSignUp(HospitalModel hospital) async {
    final json = await APIWithFromData.send(
      'hospital/addHospital',
      hospital.toMap(),
    );
    return HospitalModel.json2hospital(json);
  }
}
