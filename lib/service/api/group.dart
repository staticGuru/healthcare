import 'dart:convert';
import 'package:meddashboard/fragments/group.dart';
import 'package:meddashboard/service/api/api.dart';
import 'package:meddashboard/service/models/group_model.dart';

/// patient Group Apis
class ApiGroup {
  static Future getallgroup(hospitalid) async {
    final json = await APIWithFromData.send(
      'group/getAllGroups',
      {'hospital_id': '$hospitalid'},
    );

    List<GroupDataModel> arr = [];

    for (final el in jsonDecode(json)) {
      arr.add(GroupDataModel.map2group(el));
    }
    GroupFragment.groupId = arr[0].id;
    GroupFragment.hospitalid = hospitalid;
    return arr;
  }
}

/// api to register new Group details
class GroupSignUp {
  static Future<GroupDataModel> groupSignUp(GroupDataModel group) async {
    final json = await APIWithFromData.send(
      'group/addGroup',
      group.toMap(),
    );
    return GroupDataModel.json2group(json);
  }
}
