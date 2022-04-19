class ECGLiveModel {
  String version;
  String type;
  String patientId;
  String hospitalId;
  String deviceId;
  List<double> patientRecord;
  String emitName;

  ECGLiveModel(
      {this.version,
        this.type,
        this.patientId,
        this.hospitalId,
        this.deviceId,
        this.patientRecord,
        this.emitName});

  ECGLiveModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    type = json['type'];
    patientId = json['patient_id'];
    hospitalId = json['hospital_id'];
    deviceId = json['device_id'];
    patientRecord = json['patient_record'].cast<double>();
    emitName = json['emit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['type'] = this.type;
    data['patient_id'] = this.patientId;
    data['hospital_id'] = this.hospitalId;
    data['device_id'] = this.deviceId;
    data['patient_record'] = this.patientRecord;
    data['emit_name'] = this.emitName;
    return data;
  }
}