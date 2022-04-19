class GroupDataModel {
  String id;
  String hospitalId;
  String groupName;
  String doctorName;
  String inCharge;
  String moreDetails;
  String groupEmailAddress;
  String groupPhoneNumber;
  String groupPassword;
  String createdOn;
  String v;
  bool active = false;
  bool heartState;

  GroupDataModel({
    this.id,
    this.v,
    this.createdOn,
    this.hospitalId,
    this.doctorName,
    this.groupName,
    this.inCharge,
    this.moreDetails,
    this.groupEmailAddress,
    this.groupPassword,
    this.groupPhoneNumber,
    this.heartState = false
  });

  static GroupDataModel json2group(json) => GroupDataModel(
        id: json[0].toString(),
        hospitalId: json[1].toString(),
        groupName: json[2].toString(),
        doctorName: json[3].toString(),
        inCharge: json[4].toString(),
        moreDetails: json[5].toString(),
        groupEmailAddress: json[6].toString(),
        groupPassword: json[7].toString(),
        groupPhoneNumber: json[8].toString(),
        createdOn: json[9].toString(),
        v: json[10].toString(),
      );

  static GroupDataModel map2group(json) => GroupDataModel(
        id: json['_id'].toString(),
        hospitalId: json['hospital_id'].toString(),
        groupName: json['group_name'].toString(),
        doctorName: json['doctor_name'].toString(),
        inCharge: json['in_charge'].toString(),
        moreDetails: json['more_details'].toString(),
        groupEmailAddress: json['email_id'].toString(),
        groupPassword: json['password'].toString(),
        groupPhoneNumber: json['phone_number'].toString(),
        createdOn: json['created_on'].toString(),
        v: json['__v'].toString(),
      );

  // @override
  // String toString() =>
  //     'Hospital : $hospitalName | $hospitalAddress $hospitalphone $hospitalemail $hospitalpassword';

  @override
  Map<String, String> toMap() => {
        'hospital_id': hospitalId,
        'group_name': groupName,
        'doctor_name': doctorName,
        'in_charge': inCharge,
        'more_details': moreDetails,
        'email_id': groupEmailAddress,
        'phone_number': groupPhoneNumber,
        'password': groupPassword,
        '__v': v.toString(),
      };
}
