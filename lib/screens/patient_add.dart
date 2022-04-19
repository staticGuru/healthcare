import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/fragments/group.dart';
import 'package:meddashboard/models/card.dart';
import 'package:meddashboard/screens/main_screen.dart';
import 'package:meddashboard/service/api/patients.dart';
import 'package:meddashboard/service/models/patient_model.dart';

import '../main.dart';

class PatientAddScreen extends StatefulWidget {
  final String groupId;
  final String hospitalId;

  PatientAddScreen(this.groupId, this.hospitalId);

  @override
  _PatientAddScreenState createState() => _PatientAddScreenState();
}

class _PatientAddScreenState extends State<PatientAddScreen> {
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController ipOpController = TextEditingController();
  final TextEditingController hrUpperController = TextEditingController();
  final TextEditingController hrLowerController = TextEditingController();
  final TextEditingController pulseUpperController = TextEditingController();
  final TextEditingController pulseLowerController = TextEditingController();
  final TextEditingController sp02ThresholdController = TextEditingController();

  String gender = "Male";

  String patientNameErrorMsg;
  String patientAgeErrorMsg;
  String patientIpOpErrorMsg;
  String patientHrUpperErrorMsg;
  String patientHrLowerErrorMsg;
  String patientPulseUpperErrorMsg;
  String patientPulseLowerErrorMsg;
  String patientSp02ThresholdErrorMsg;

  submitOnTap() async {

    setState(() {
      patientNameErrorMsg = (patientNameController.text.isEmpty)
          ? "Please enter Patient's Name"
          : null;
      patientAgeErrorMsg = (ageController.text.isEmpty)
          ? "Please enter valid Patient Age"
          : null;
      patientIpOpErrorMsg =
          (ipOpController.text.isEmpty) ? "Please enter IP/OP Number" : null;
      patientHrUpperErrorMsg = (hrUpperController.text.isEmpty)
          ? "Please enter Heart rate Upper Limit"
          : null;
      patientHrLowerErrorMsg = (hrLowerController.text.isEmpty)
          ? "Please enter Heart rate Lower Limit"
          : null;
      patientPulseUpperErrorMsg = (pulseUpperController.text.isEmpty)
          ? "Please enter Pulse rate Upper Limit"
          : null;
      patientPulseLowerErrorMsg = (pulseLowerController.text.isEmpty)
          ? "Please enter Pulse rate Lower Limit"
          : null;
      patientSp02ThresholdErrorMsg = (sp02ThresholdController.text.isEmpty)
          ? "Please enter Sp02 Threshold"
          : null;
    });
    if (patientNameErrorMsg == null &&
        patientAgeErrorMsg == null &&
        patientIpOpErrorMsg == null &&
        patientHrUpperErrorMsg == null &&
        patientHrLowerErrorMsg == null &&
        patientPulseUpperErrorMsg == null) {
      await ApiPatient.addNewPatients(
        PatientModel(
          id: "",
          hospital_id: widget.hospitalId,
          group_id: widget.groupId,
          patient_name: patientNameController.text,
          age: int.parse(ageController.text),
          gender: gender == "Male" ? 'm' : 'f',
          ip_op_io_num: ipOpController.text,
          hr_upper_limit: int.parse(hrUpperController.text),
          hr_lower_limit: int.parse(hrLowerController.text),
          pulse_upper_limit: int.parse(pulseUpperController.text),
          pulse_lower_limit: int.parse(pulseLowerController.text),
          spo2_threshold: int.parse(sp02ThresholdController.text),
          v: "",
        ),
      );

      MainScreen.allPatients.add(
        CardModel(
          PatientModel(
            id: "",
            hospital_id: widget.hospitalId,
            group_id: widget.groupId,
            patient_name: patientNameController.text,
            age: int.parse(ageController.text),
            gender: gender == "Male" ? 'm' : 'f',
            ip_op_io_num: ipOpController.text,
            hr_upper_limit: int.parse(hrUpperController.text),
            hr_lower_limit: int.parse(hrLowerController.text),
            pulse_upper_limit: int.parse(pulseUpperController.text),
            pulse_lower_limit: int.parse(pulseLowerController.text),
            spo2_threshold: int.parse(sp02ThresholdController.text),
            v: "",
          ),
          pinned: false,
          devices: [],
        ),
      );
      GroupFragment.getPatient();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 420,
        height: 625,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add patient',
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
                              width: 400,
                              height: 58,
                              child: TextField(
                                controller: patientNameController,
                                onChanged: (value) {
                                  setState(() {
                                    patientNameErrorMsg = (value == "")
                                        ? "Please enter Patient Name"
                                        : null;
                                  });
                                },
                                decoration: InputDecoration(
                                    errorText: patientNameErrorMsg,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.darkBlue, width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.linkBlue, width: 1),
                                    ),
                                    labelText: "Patient Name"),
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
                                      onChanged: (value) {
                                        List<int> asciis = [];
                                        asciis.addAll(value.codeUnits);
                                        setState(() {
                                          patientAgeErrorMsg = (value == "" ||
                                                  value.codeUnits[
                                                          value.length - 1] <
                                                      48 ||
                                                  value.codeUnits[
                                                          value.length - 1] >
                                                      57)
                                              ? "Please enter valid Patient's Age"
                                              : null;
                                        });
                                      },
                                      controller: ageController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          errorText: patientAgeErrorMsg,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.darkBlue,
                                                width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.linkBlue,
                                                width: 1),
                                          ),
                                          labelText: "Age"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.darkBlue,
                                                width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.linkBlue,
                                                width: 1),
                                          ),
                                          labelText: "Gender"),
                                      onChanged: (value) {
                                        gender = value;
                                      },
                                      value: gender,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('Male'),
                                          value: 'Male',
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Female'),
                                          value: 'Female',
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Non-binary'),
                                          value: 'Non-binary',
                                        )
                                      ],
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
                                controller: ipOpController,
                                onChanged: (value) {
                                  setState(() {
                                    patientIpOpErrorMsg = (value == "")
                                        ? "Please enter IP/OP Number"
                                        : null;
                                  });
                                },
                                decoration: InputDecoration(
                                    errorText: patientIpOpErrorMsg,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.darkBlue, width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.linkBlue, width: 1),
                                    ),
                                    labelText: "IP/OP Number"),
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
                                      controller: hrUpperController,
                                      onChanged: (value) {
                                        setState(() {
                                          patientHrUpperErrorMsg = (value ==
                                                      "" ||
                                                  value.codeUnits[
                                                          value.length - 1] <
                                                      48 ||
                                                  value.codeUnits[
                                                          value.length - 1] >
                                                      57)
                                              ? "Please enter Valid Heart rate Upper Limit"
                                              : null;
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          errorText: patientHrUpperErrorMsg,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.darkBlue,
                                                width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.linkBlue,
                                                width: 1),
                                          ),
                                          labelText: "Heart rate Upper Limit"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: hrLowerController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          patientHrLowerErrorMsg = (value ==
                                                      "" ||
                                                  value.codeUnits[
                                                          value.length - 1] <
                                                      48 ||
                                                  value.codeUnits[
                                                          value.length - 1] >
                                                      57)
                                              ? "Please enter Valid Heart rate Lower Limit"
                                              : null;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          errorText: patientHrLowerErrorMsg,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.darkBlue,
                                                width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.linkBlue,
                                                width: 1),
                                          ),
                                          labelText: "Heart rate Lower Limit"),
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
                                      controller: pulseUpperController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          patientPulseUpperErrorMsg = (value ==
                                                      "" ||
                                                  value.codeUnits[
                                                          value.length - 1] <
                                                      48 ||
                                                  value.codeUnits[
                                                          value.length - 1] >
                                                      57)
                                              ? "Please enter Valid Pulse rate Upper Limit"
                                              : null;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          errorText: patientPulseUpperErrorMsg,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.darkBlue,
                                                width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.linkBlue,
                                                width: 1),
                                          ),
                                          labelText: "Pulse rate Upper Limit"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: pulseLowerController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          patientPulseLowerErrorMsg = (value ==
                                                      "" ||
                                                  value.codeUnits[
                                                          value.length - 1] <
                                                      48 ||
                                                  value.codeUnits[
                                                          value.length - 1] >
                                                      57)
                                              ? "Please enter Valid Pulse rate Lower Limit"
                                              : null;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          errorText: patientPulseLowerErrorMsg,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.darkBlue,
                                                width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Style.linkBlue,
                                                width: 1),
                                          ),
                                          labelText: "Pulse rate Lower Limit"),
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
                                controller: sp02ThresholdController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    patientSp02ThresholdErrorMsg = (value ==
                                                "" ||
                                            value.codeUnits[value.length - 1] <
                                                48 ||
                                            value.codeUnits[value.length - 1] >
                                                57)
                                        ? "Please enter Valid Sp02 Threshold"
                                        : null;
                                  });
                                },
                                decoration: InputDecoration(
                                    errorText: patientSp02ThresholdErrorMsg,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.darkBlue, width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.linkBlue, width: 1),
                                    ),
                                    labelText: "Sp02 Threshold"),
                              ),
                            ),

                            SizedBox(
                              height: 16,
                            ),
                            Material(
                              color: Style.darkBlue,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () => submitOnTap(),
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  height: 48,
                                  width: 260,
                                  child: Center(
                                      child: Text(
                                    'Add Patient',
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
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
