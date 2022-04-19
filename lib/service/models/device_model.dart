class DeviceModel {
  String id;
  String deviceId;
  String patientId;
  String deviceSerialNumber;
  String deviceType;
  String addedOn;
  String v;
  String battery;

  DeviceModel({
    this.id,
    this.patientId,
    this.deviceId,
    this.deviceSerialNumber,
    this.deviceType,
    this.addedOn,
    this.v,
    this.battery,
  });

  static DeviceModel json2device(json) => DeviceModel(
        id: json[0].toString(),
        patientId: json[1].toString(),
        deviceId: json[2].toString(),
        deviceSerialNumber: json[3].toString(),
        deviceType: json[4],
        addedOn: json[5].toString(),
        v: json[6].toString(),
        battery: json[7].toString(),
      );

  static DeviceModel map2Device(data) => DeviceModel(
        id: data['_id'].toString(),
        patientId: data['patient_id'].toString(),
        deviceId: data['device_id'].toString(),
        deviceSerialNumber: data['serial_num'].toString(),
        deviceType: data['type'].toString(),
        addedOn: data['added_on'].toString(),
        v: data['__v'].toString(),
        battery: data['battery_per'].toString(),
      );

  // @override
  // String toString() =>
  //     'device : $deviceName | $deviceAddress $devicePhone $deviceEmail $devicePassword';

  @override
  Map<String, String> toMap() => {
        'patient_id': patientId,
        'serial_num': deviceSerialNumber,
        'type': deviceType.toString(),
      };
}
