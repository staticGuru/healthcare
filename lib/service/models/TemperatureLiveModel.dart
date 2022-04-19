class TemperatureLiveModel {
  String version;
  String type;
  String patientId;
  String hospitalId;
  String patientRecord;
  String deviceId;
  String emitName;

  TemperatureLiveModel(
      {this.version,
        this.type,
        this.patientId,
        this.hospitalId,
        this.patientRecord,
        this.deviceId,
        this.emitName});

  TemperatureLiveModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    type = json['type'];
    patientId = json['patient_id'];
    hospitalId = json['hospital_id'];
    patientRecord = json['patient_record'];
    deviceId = json['device_id'];
    emitName = json['emit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['type'] = this.type;
    data['patient_id'] = this.patientId;
    data['hospital_id'] = this.hospitalId;
    data['patient_record'] = this.patientRecord;
    data['device_id'] = this.deviceId;
    data['emit_name'] = this.emitName;
    return data;
  }
}