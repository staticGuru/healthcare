import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/service/api/group.dart';
import 'package:meddashboard/service/models/group_model.dart';
import 'package:meddashboard/service/models/hopital_model.dart';

import '../main.dart';

class GroupAddScreen extends StatefulWidget {
  final List<HospitalModel> hospitalList;

  GroupAddScreen(this.hospitalList);

  @override
  _GroupAddScreenState createState() => _GroupAddScreenState();
}

class _GroupAddScreenState extends State<GroupAddScreen> {
  HospitalModel hospitalDropDownValue;

  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  signUpOnTapGroup() async {
    setState(() {
      //Group
      groupNameErrorMsg =
          (groupNameController.text.isEmpty) ? "Please enter Group's Name" : "";
      groupInChargeErrorMsg = (groupInChargeController.text.isEmpty)
          ? "Please enter Group's Address"
          : "";
      groupPhoneErrorMsg = (groupPhoneController.text.isEmpty) ? "Please enter Group's Phone Number" : "";
      groupEmailErrorMsg = (groupEmailController.text.isEmpty) ? "Please enter Group's Address" : "";
      groupPasswordErrorMsg =
          (groupPasswordController.text.isEmpty) ? "Please enter Password" : "";
      groupConfirmPasswordErrorMsg =
          (groupConfirmPasswordController.text.isEmpty)
              ? "Please enter Confirm Password"
              : "";
    });
    if (groupNameErrorMsg == "" &&
        groupInChargeErrorMsg == "" &&
        groupPhoneErrorMsg == "" &&
        groupEmailErrorMsg == "" &&
        groupPasswordErrorMsg == "" &&
        groupConfirmPasswordErrorMsg == "")
      await GroupSignUp.groupSignUp(
        GroupDataModel(
          hospitalId: selectedHospitalId,
          groupName: groupNameController.text,
          doctorName: groupDoctorNameController.text,
          inCharge: groupInChargeController.text,
          moreDetails: groupMoreDetailController.text,
          groupEmailAddress: groupEmailController.text,
          groupPassword: groupPasswordController.text,
          groupPhoneNumber: groupPhoneController.text,
        ),
      ).then((value) {
        if (value != null)
          setState(() {
            Navigator.pop(context);
          });
      });
  }

  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupInChargeController = TextEditingController();
  TextEditingController groupDoctorNameController = TextEditingController();
  TextEditingController groupPhoneController = TextEditingController();
  TextEditingController groupEmailController = TextEditingController();
  TextEditingController groupPasswordController = TextEditingController();
  TextEditingController groupConfirmPasswordController =
      TextEditingController();
  TextEditingController groupMoreDetailController = TextEditingController();
  String groupNameErrorMsg = "";
  String groupInChargeErrorMsg = "";
  String groupPhoneErrorMsg = "";
  String groupEmailErrorMsg = "";
  String groupPasswordErrorMsg = "";
  String groupConfirmPasswordErrorMsg = "";
  String selectedHospitalId = "";

  Widget errorMsgWidget(String message) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      );

  @override
  void initState() {
    hospitalDropDownValue = widget.hospitalList[0];
    selectedHospitalId = hospitalDropDownValue.hospitalId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 420,
        height: 500,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Add group',
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
                SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 58,
                        child: TextField(
                          controller: groupNameController,
                          onChanged: (value) {
                            setState(() {
                              groupNameErrorMsg = (value == "")
                                  ? "Please enter Group's Name"
                                  : "";
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.darkBlue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.linkBlue, width: 1),
                              ),
                              labelText: "Group Name"),
                        ),
                      ),
                      errorMsgWidget(groupNameErrorMsg),
                      SizedBox(
                        height: 8,
                      ),
                      DropdownButtonFormField(
                        icon: Icon(
                          MdiIcons.arrowDownDropCircle,
                          color: Colors.red,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Style.darkBlue, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Style.linkBlue, width: 1),
                          ),
                          labelText: "Hospital",
                        ),
                        onChanged: (HospitalModel value) {
                          hospitalDropDownValue = value;
                          selectedHospitalId = value.hospitalId;
                        },
                        value: hospitalDropDownValue,
                        items: [
                          for (int i = 0; i < widget.hospitalList.length; i++)
                            DropdownMenuItem(
                              child: Text(widget.hospitalList[i].hospitalName),
                              value: widget.hospitalList[i],
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 58,
                        child: TextField(
                          controller: groupDoctorNameController,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.darkBlue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.linkBlue, width: 1),
                              ),
                              labelText: "Doctor Name"),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 58,
                        child: TextField(
                          controller: groupInChargeController,
                          onChanged: (value) {
                            setState(() {
                              groupInChargeErrorMsg = (value == "")
                                  ? "Please enter Group's In-Charge Name"
                                  : "";
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.darkBlue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.linkBlue, width: 1),
                              ),
                              labelText: "In-charge Name"),
                        ),
                      ),
                      errorMsgWidget(groupInChargeErrorMsg),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 58,
                        child: TextField(
                          controller: groupPhoneController,
                          onChanged: (value) {
                            setState(() {
                              groupPhoneErrorMsg = (value == "")
                                  ? "Please enter Group's Phone Number"
                                  : "";
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.darkBlue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.linkBlue, width: 1),
                              ),
                              labelText: "Phone Number"),
                        ),
                      ),
                      errorMsgWidget(groupPhoneErrorMsg),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 58,
                        child: TextField(
                          controller: groupEmailController,
                          onChanged: (value) {
                            setState(() {
                              groupEmailErrorMsg = (value == "")
                                  ? "Please enter Group's Email Address"
                                  : "";

                              String email = value;
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email);
                              groupEmailErrorMsg = (!emailValid)
                                  ? "Please enter Valid Group's Email Address"
                                  : "";
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Style.darkBlue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Style.linkBlue, width: 1),
                            ),
                            labelText: "Email Address",
                          ),
                        ),
                      ),
                      errorMsgWidget(groupEmailErrorMsg),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 58,
                        child: TextField(
                          controller: groupMoreDetailController,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.darkBlue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.linkBlue, width: 1),
                              ),
                              labelText: "More Detail"),
                          minLines: 2,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 58,
                        child: TextField(
                          controller: groupPasswordController,
                          onChanged: (value) {
                            setState(() {
                              groupPasswordErrorMsg =
                                  (value == "") ? "Please enter Password" : "";
                              if (value.length < 8)
                                groupPasswordErrorMsg =
                                    "Please Enter minimum 8 Letters or Number";
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Style.darkBlue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Style.linkBlue, width: 1),
                            ),
                            labelText: "Password",
                            suffixIcon: IconButton(
                                icon: Icon(
                                  !passwordVisibility
                                      ? MdiIcons.eyeOff
                                      : MdiIcons.eye,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                }),
                          ),
                          obscureText: passwordVisibility,
                        ),
                      ),
                      errorMsgWidget(groupPasswordErrorMsg),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 58,
                        child: TextField(
                          controller: groupConfirmPasswordController,
                          onChanged: (value) {
                            setState(() {
                              if (value == "")
                                groupConfirmPasswordErrorMsg =
                                    "Please enter Confirm Password";

                              groupConfirmPasswordErrorMsg = (value !=
                                      groupPasswordController.text)
                                  ? "Password and Confirm Password must be match"
                                  : "";
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Style.darkBlue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Style.linkBlue, width: 1),
                            ),
                            labelText: "Confirm Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                !confirmPasswordVisibility
                                    ? MdiIcons.eyeOff
                                    : MdiIcons.eye,
                              ),
                              onPressed: () {
                                setState(() {
                                  confirmPasswordVisibility =
                                      !confirmPasswordVisibility;
                                });
                              },
                            ),
                          ),
                          obscureText: confirmPasswordVisibility,
                        ),
                      ),
                      errorMsgWidget(groupConfirmPasswordErrorMsg),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Material(
                  color: Style.darkBlue,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => signUpOnTapGroup(),
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 48,
                      width: 260,
                      child: Center(
                        child: Text(
                          'Add Group',
                          style: GoogleFonts.montserrat(
                            color: Style.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
