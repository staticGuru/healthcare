import 'dart:async';
import 'package:rxdart/rxdart.dart';

class StreamSocket{

//  static socketResponse= StreamController<String>();

  static StreamController<String> _socketResponse = BehaviorSubject();

  static Function(String) get addResponse => _socketResponse.sink.add;

  static Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }

}
