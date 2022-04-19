class HospitalModel {
  String hospitalId;
  String hospitalName;
  String hospitalAddress;
  String hospitalPhone;
  String hospitalEmail;
  String hospitalPassword;
  String createdOn;
  String v;

  HospitalModel({
    this.hospitalId,
    this.hospitalName,
    this.hospitalAddress,
    this.hospitalPhone,
    this.hospitalEmail,
    this.hospitalPassword,
    this.createdOn,
    this.v,
  });

  static HospitalModel json2hospital(json) => HospitalModel(
        hospitalId: json[0].toString(),
        hospitalName: json[1].toString(),
        hospitalAddress: json[2].toString(),
        hospitalPhone: json[3].toString(),
        hospitalEmail: json[4].toString(),
        hospitalPassword: json[5].toString(),
        createdOn: json[6].toString(),
        v: json[7].toString(),
      );

  static HospitalModel map2Hospital(data) => HospitalModel(
        hospitalId: data['_id'].toString(),
        hospitalName: data['hospital_name'].toString(),
        hospitalAddress: data['hospital_address'].toString(),
        hospitalPhone: data['hospital_phone'].toString(),
        hospitalEmail: data['hospital_email'].toString(),
        hospitalPassword: data['hospital_password'].toString(),
        createdOn: data['created_on'].toString(),
        v: data['__v'].toString(),
      );

  // @override
  // String toString() =>
  //     'Hospital : $hospitalName | $hospitalAddress $hospitalPhone $hospitalEmail $hospitalPassword';

  @override
  Map<String, String> toMap() => {
        'hospital_name': hospitalName,
        'hospital_address': hospitalAddress,
        'hospital_phone': hospitalPhone,
        'hospital_email': hospitalEmail,
        'hospital_password': hospitalPassword,
        '__v': v.toString(),
      };
}
