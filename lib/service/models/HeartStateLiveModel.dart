class HeartStateLiveModel {
  String version;
  String type;
  String patientId;
  String hospitalId;
  String deviceId;
  String groupId;
  String patName;
  String groupName;
  String patientRecord;
  String emitName;
  String alertDetails;

  HeartStateLiveModel(
      {this.version,
        this.type,
        this.patientId,
        this.hospitalId,
        this.deviceId,
        this.groupId,
        this.patName,
        this.groupName,
        this.patientRecord,
        this.alertDetails,
        this.emitName});

  HeartStateLiveModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    type = json['type'];
    patientId = json['patient_id'];
    hospitalId = json['hospital_id'];
    deviceId = json['device_id'];
    groupId = json['group_id'];
    patName = json['patient_name'];
    groupName = json['group_name'];
    patientRecord = json['patient_record'];
    emitName = json['emit_name'];
    alertDetails = json['alert_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['type'] = this.type;
    data['patient_id'] = this.patientId;
    data['hospital_id'] = this.hospitalId;
    data['device_id'] = this.deviceId;
    data['group_id'] = this.groupId;
    data['pat_name'] = this.patName;
    data['group_name'] = this.groupName;
    data['patient_record'] = this.patientRecord;
    data['emit_name'] = this.emitName;
    data['alert_details'] = this.alertDetails;
    return data;
  }

}