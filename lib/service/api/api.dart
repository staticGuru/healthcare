import 'dart:html';

import 'package:http/http.dart' as http;

///// api to fetch data without passing args

class API {
  static Future<String> send(String url, [args]) async =>
      (await http.post('http://65.1.31.6:5000/$url',
              headers: {'Content-Type': 'application/json'}, body: args))
          .body;
}

///// apito fetch data by passing args
class APII {
  static Future<String> send(String url, String args) async =>
      (await http.post('http://65.1.31.6:5000/$url',
              headers: {'Content-Type': 'application/json'}, body: args))
          .body;
}

///// api to fetch data by passing args with FromData
class APIWithFromData {
  static Future send(String url, Map<String, String> args) async =>
      (await HttpRequest.postFormData(
        'http://65.1.31.6:5000/$url',
        args,
        requestHeaders: {'Content-Type': 'application/x-www-form-urlencoded'},
      ))
          .response;
}
