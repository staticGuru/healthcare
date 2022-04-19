import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/models/card.dart';
import 'package:meddashboard/service/api/patients.dart';
import 'package:meddashboard/service/models/group_model.dart';
import 'package:meddashboard/service/models/patient_model.dart';

import '../main.dart';

class PatientSettingsScreen extends StatelessWidget {
  final CardModel patientData;
  final List<GroupDataModel> groupList;
  final String hospitalId;

  PatientSettingsScreen(this.patientData, this.groupList, this.hospitalId);

  String gender = "";
  String group = "";

  TextEditingController userNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController hrUpperController = TextEditingController();
  TextEditingController hrLowerController = TextEditingController();
  TextEditingController prUpperController = TextEditingController();
  TextEditingController prLowerController = TextEditingController();
  TextEditingController sp02ThresholdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    group = groupList[0].id.toString();
    List<DropdownMenuItem<String>> items = groupList
        .map(
          (e) => DropdownMenuItem(
            child: Text(e.groupName),
            value: e.id,
          ),
        )
        .toList();
    gender = patientData.patient.gender.toString();
    return Center(
      child: SizedBox(
        width: 590,
        height: 550,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Patient Settings',
                      style: GoogleFonts.poppins(
                          color: Style.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(MdiIcons.close)),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: 400,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 58,
                          child: TextField(
                            controller: userNameController
                              ..text = patientData.name ?? ",",
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.darkBlue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.linkBlue, width: 1),
                              ),
                              labelText: "Patient Name",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 58,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: ageController
                                    ..text = patientData.age.toString() ?? "",
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.darkBlue,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.linkBlue, width: 1),
                                    ),
                                    labelText: "Age",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.darkBlue,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.linkBlue, width: 1),
                                    ),
                                    labelText: "Gender",
                                  ),
                                  onChanged: (val) {
                                    gender = val;
                                  },
                                  value: gender,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('Male'),
                                      value: 'm',
                                    ),
                                    DropdownMenuItem(
                                      child: Text('Female'),
                                      value: 'f',
                                    ),
                                    DropdownMenuItem(
                                      child: Text('Non-binary'),
                                      value: 'non-binary',
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.darkBlue,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.linkBlue,
                                        width: 1,
                                      ),
                                    ),
                                    labelText: "Group",
                                  ),
                                  onChanged: (val) {
                                    group = val;
                                  },
                                  // value: group,
                                  items: items,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        // all the medical stuff
                        SizedBox(
                          height: 58,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: hrUpperController
                                    ..text = patientData.patient.hr_upper_limit.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.darkBlue,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.linkBlue,
                                        width: 1,
                                      ),
                                    ),
                                    labelText: "Heart rate Upper Limit",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: hrLowerController
                                    ..text = patientData.patient.hr_lower_limit.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.darkBlue,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.linkBlue,
                                        width: 1,
                                      ),
                                    ),
                                    labelText: "Heart rate Lower Limit",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 58,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: prUpperController
                                    ..text =
                                        patientData.patient.pulse_upper_limit.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.darkBlue,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.linkBlue,
                                        width: 1,
                                      ),
                                    ),
                                    labelText: "Pulse rate Upper Limit",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: prLowerController
                                    ..text =
                                        patientData.patient.pulse_lower_limit.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.darkBlue,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.linkBlue,
                                        width: 1,
                                      ),
                                    ),
                                    labelText: "Pulse rate Lower Limit",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 58,
                          child: TextField(
                            controller: sp02ThresholdController
                              ..text = patientData.patient.spo2_threshold.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Style.darkBlue,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Style.linkBlue,
                                  width: 1,
                                ),
                              ),
                              labelText: "Sp02 Threshold",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Material(
                          color: Style.darkBlue,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () async {
                              await ApiPatient.updatePatients(
                                PatientModel(
                                  id: patientData.patientId,
                                  hospital_id: hospitalId,
                                  group_id: group,
                                  patient_name: userNameController.text,
                                  age: int.parse(ageController.text),
                                  gender: gender,
                                  hr_upper_limit: int.parse(hrUpperController.text),
                                  hr_lower_limit: int.parse(hrLowerController.text),
                                  pulse_upper_limit: int.parse(prUpperController.text),
                                  pulse_lower_limit: int.parse(prLowerController.text),
                                  spo2_threshold: int.parse(sp02ThresholdController.text),
                                  ip_op_io_num: "",
                                  v: "",
                                ),
                              );
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 48,
                              width: 260,
                              child: Center(
                                  child: Text(
                                'Save',
                                style: GoogleFonts.montserrat(
                                    color: Style.white, fontSize: 18),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
