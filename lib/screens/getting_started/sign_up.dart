import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/screens/getting_started/sign_in.dart';
import 'package:meddashboard/service/api/doctor.dart';
import 'package:meddashboard/service/api/group.dart';
import 'package:meddashboard/service/api/hospitals.dart';
import 'package:meddashboard/service/models/doctor_model.dart';
import 'package:meddashboard/service/models/group_model.dart';
import 'package:meddashboard/service/models/hopital_model.dart';

import '../../main.dart';

List<HospitalModel> hospitalList = [];
String selectedHospitalId = "";

getHospital() async {
  hospitalList.clear();
  hospitalList = await APIHospitals.getHospitals();
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool agreeToPolicy = false;
  String dropdownGroup;

  @override
  void initState() {
    getHospital();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.bgBlue,
      body: Padding(
        padding: EdgeInsets.all(28),
        child: Center(
          child: SizedBox(
            width: 400,
            child: ListView(
              children: [
                Center(
                    child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                )

                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Text(
                    //       'Witals',
                    //       style: GoogleFonts.poppins(
                    //           color: Style.black,
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 28),
                    //     ),
                    //     Text(
                    //       '24',
                    //       style: GoogleFonts.poppins(
                    //           color: Style.darkBlue,
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 28),
                    //     ),
                    //   ],
                    // ),
                    ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 58,
                  child: DropdownButtonFormField(
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
                        labelText: "Select as"),
                    onChanged: (_) => setState(() => dropdownGroup = _),
                    value: dropdownGroup,
                    items: [
                      DropdownMenuItem(
                        child: Text('Doctor'),
                        value: 'doctor',
                      ),
                      DropdownMenuItem(
                        child: Text('Hospital'),
                        value: 'hospital',
                      ),
                      DropdownMenuItem(
                        child: Text('Group'),
                        value: 'group',
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                if (dropdownGroup == 'hospital') SignUpScreenHospital(),
                if (dropdownGroup == 'doctor') SignUpScreenDoctor(),
                if (dropdownGroup == 'group') SignUpScreenGroup(),
                SizedBox(
                  height: 6,
                ),
                // if (dropdownGroup != null)
                //   Container(
                //     child: Row(
                //       children: [
                //         Checkbox(
                //             value: agreeToPolicy,
                //             onChanged: (v) =>
                //                 setState(() => agreeToPolicy = v)),
                //         Text('I agree to '),
                //         GestureDetector(
                //           onTap: () => launch('https://google.com'),
                //           child: Text(
                //             'Terms & Conditions',
                //             style: TextStyle(color: Style.linkBlue),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                SizedBox(
                  height: 18,
                ),
                if (dropdownGroup != null)
                  Material(
                    color: Style.darkBlue,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        if (dropdownGroup == 'hospital') signUpOnTapHospital();
                        // if (dropdownGroup == 'doctor')
                        if (dropdownGroup == 'group') signUpOnTapGroup();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 48,
                        width: 260,
                        child: Center(
                            child: Text(
                          'Sign Up',
                          style: GoogleFonts.montserrat(
                              color: Style.white, fontSize: 18),
                        )),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 12,
                ),
                FlatButton(
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (ctx) => SignInScreen())),
                    child: Text('Sign In', style: GoogleFonts.firaMono()))
              ],
            ),
          ),
        ),
      ),
    );
  }

  signUpOnTapHospital() async {
    setState(() {
      //Hospital
      hospitalNameErrorMsg = (hospitalNameController.text.isEmpty)
          ? "Please enter Hospital's Name"
          : "";
      hospitalAddressErrorMsg = (hospitalAddressController.text.isEmpty)
          ? "Please enter Hospital's Address"
          : "";
      hospitalPhoneErrorMsg = (hospitalPhoneController.text.isEmpty)
          ? "Please enter Hospital's Phone Number"
          : "";
      hospitalEmailErrorMsg = (hospitalEmailController.text.isEmpty)
          ? "Please enter Hospital's Address"
          : "";
      hospitalPasswordErrorMsg = (hospitalPasswordController.text.isEmpty)
          ? "Please enter Password"
          : "";
      hospitalConfirmPasswordErrorMsg =
          (hospitalConfirmPasswordController.text.isEmpty)
              ? "Please enter Confirm Password"
              : "";
    });
    if (hospitalNameErrorMsg == "" &&
        hospitalAddressErrorMsg == "" &&
        hospitalPhoneErrorMsg == "" &&
        hospitalEmailErrorMsg == "" &&
        hospitalPasswordErrorMsg == "" &&
        hospitalConfirmPasswordErrorMsg == "") {
      HospitalModel value = await HospitalSignUp.hospitalSignUp(
        HospitalModel(
          hospitalId: "",
          hospitalName: hospitalNameController.text,
          hospitalAddress: hospitalAddressController.text,
          hospitalPhone: hospitalPhoneController.text,
          hospitalEmail: hospitalEmailController.text,
          hospitalPassword: hospitalPasswordController.text,
        ),
      );
      if (value != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => SignInScreen(),
          ),
        );
      }
    }
  }

  signUpOnTapDoctor() async {
    setState(() {
      doctorNameErrorMsg = (doctorNameController.text.isEmpty)
          ? "Please enter Doctor's Name"
          : "";
      doctorDepartmentErrorMsg = (doctorDepartmentController.text.isEmpty)
          ? "Please enter Doctor's Department"
          : "";
      doctorPhoneErrorMsg = (doctorPhoneController.text.isEmpty)
          ? "Please enter Doctor's Phone Number"
          : "";
      doctorEmailErrorMsg = (doctorEmailController.text.isEmpty)
          ? "Please enter Doctor's Email Address"
          : "";
      doctorPasswordErrorMsg = (doctorPasswordController.text.isEmpty)
          ? "Please enter Password"
          : "";
      doctorConfirmPasswordErrorMsg =
          (doctorConfirmPasswordController.text.isEmpty)
              ? "Please enter Confirm Password"
              : "";
    });
    if (doctorNameErrorMsg == "" &&
        doctorDepartmentErrorMsg == "" &&
        doctorPhoneErrorMsg == "" &&
        doctorEmailErrorMsg == "" &&
        doctorPasswordErrorMsg == "" &&
        doctorConfirmPasswordErrorMsg == "") {
      var val = await DoctorSignUp.doctorSignUp(DoctorModel());
      if (val != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => SignInScreen(),
          ),
        );
      }
    }
  }

  signUpOnTapGroup() async {
    setState(() {
      groupNameErrorMsg =
          (groupNameController.text.isEmpty) ? "Please enter Group's Name" : "";
      groupInChargeErrorMsg = (groupInChargeController.text.isEmpty)
          ? "Please enter Group's In-Charge Name"
          : "";
      groupPhoneErrorMsg = (groupPhoneController.text.isEmpty)
          ? "Please enter Group's Phone Number"
          : "";
      groupEmailErrorMsg = (groupEmailController.text.isEmpty)
          ? "Please enter Group's Email Address"
          : "";
      // groupEmailErrorMsg =
      //     (emailValid) ? "Please enter Valid Group's Email Address" : "";
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
        groupConfirmPasswordErrorMsg == "") {
      var val = await GroupSignUp.groupSignUp(GroupDataModel(
        hospitalId: selectedHospitalId,
        groupName: groupNameController.text,
        doctorName: groupDoctorNameController.text,
        inCharge: groupInChargeController.text,
        moreDetails: groupMoreDetailController.text,
        groupEmailAddress: groupEmailController.text,
        groupPassword: groupPasswordController.text,
        groupPhoneNumber: groupPhoneController.text,
      ));
      if (val != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => SignInScreen(),
          ),
        );
      }
    }
  }
}

/// GROUP SIGN UP
TextEditingController groupNameController = TextEditingController();
TextEditingController groupInChargeController = TextEditingController();
TextEditingController groupDoctorNameController = TextEditingController();
TextEditingController groupPhoneController = TextEditingController();
TextEditingController groupEmailController = TextEditingController();
TextEditingController groupPasswordController = TextEditingController();
TextEditingController groupConfirmPasswordController = TextEditingController();
TextEditingController groupMoreDetailController = TextEditingController();
String groupNameErrorMsg = "";
String groupInChargeErrorMsg = "";
String groupPhoneErrorMsg = "";
String groupEmailErrorMsg = "";
String groupPasswordErrorMsg = "";
String groupConfirmPasswordErrorMsg = "";

class SignUpScreenGroup extends StatefulWidget {
  @override
  _SignUpScreenGroupState createState() => _SignUpScreenGroupState();
}

class _SignUpScreenGroupState extends State<SignUpScreenGroup> {
  HospitalModel hospitalDropDownValue;
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 58,
          child: TextField(
            controller: groupNameController,
            onChanged: (value) {
              setState(() {
                groupNameErrorMsg =
                    (value == "") ? "Please enter Group's Name" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Group Name"),
          ),
        ),
        errorMsgWidget(groupNameErrorMsg),
        DropdownButtonFormField(
          icon: Icon(
            MdiIcons.arrowDownDropCircle,
            color: Colors.red,
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Style.darkBlue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Style.linkBlue, width: 1),
            ),
            labelText: "Hospital",
          ),
          onChanged: (HospitalModel value) {
            hospitalDropDownValue = value;
            selectedHospitalId = value.hospitalId;
          },
          value: hospitalDropDownValue,
          items: [
            for (int i = 0; i < hospitalList.length; i++)
              DropdownMenuItem(
                child: Text(hospitalList[i].hospitalName),
                value: hospitalList[i],
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
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
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
                groupInChargeErrorMsg =
                    (value == "") ? "Please enter Group's In-Charge Name" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
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
                groupPhoneErrorMsg =
                    (value == "") ? "Please enter Group's Phone Number" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
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
                groupEmailErrorMsg =
                    (value == "") ? "Please enter Group's Email Address" : "";

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
                borderSide: BorderSide(color: Style.darkBlue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.linkBlue, width: 1),
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
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
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
                borderSide: BorderSide(color: Style.darkBlue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.linkBlue, width: 1),
              ),
              labelText: "Password",
              suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisibility ? MdiIcons.eyeOff : MdiIcons.eye,
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

                groupConfirmPasswordErrorMsg =
                    (value != groupPasswordController.text)
                        ? "Password and Confirm Password must be match"
                        : "";
              });
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.darkBlue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.linkBlue, width: 1),
              ),
              labelText: "Confirm Password",
              suffixIcon: IconButton(
                icon: Icon(
                  confirmPasswordVisibility ? MdiIcons.eyeOff : MdiIcons.eye,
                ),
                onPressed: () {
                  setState(() {
                    confirmPasswordVisibility = !confirmPasswordVisibility;
                  });
                },
              ),
            ),
            obscureText: confirmPasswordVisibility,
          ),
        ),
        errorMsgWidget(groupConfirmPasswordErrorMsg),
      ],
    );
  }
}

/// DOCTOR SIGN UP
TextEditingController doctorNameController = TextEditingController();
TextEditingController doctorDepartmentController = TextEditingController();
TextEditingController doctorPhoneController = TextEditingController();
TextEditingController doctorEmailController = TextEditingController();
TextEditingController doctorPasswordController = TextEditingController();
TextEditingController doctorConfirmPasswordController = TextEditingController();
String doctorNameErrorMsg = "";
String doctorDepartmentErrorMsg = "";
String doctorPhoneErrorMsg = "";
String doctorEmailErrorMsg = "";
String doctorPasswordErrorMsg = "";
String doctorConfirmPasswordErrorMsg = "";

class SignUpScreenDoctor extends StatefulWidget {
  @override
  _SignUpScreenDoctorState createState() => _SignUpScreenDoctorState();
}

class _SignUpScreenDoctorState extends State<SignUpScreenDoctor> {
  HospitalModel hospitalDropDownValue;
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 58,
          child: TextField(
            controller: doctorNameController,
            onChanged: (value) {
              setState(() {
                doctorNameErrorMsg =
                    (value == "") ? "Please enter Doctor's Name" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Doctor Name"),
          ),
        ),
        errorMsgWidget(doctorNameErrorMsg),
        DropdownButtonFormField(
          icon: Icon(
            MdiIcons.arrowDownDropCircle,
            color: Colors.red,
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Style.darkBlue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Style.linkBlue, width: 1),
            ),
            labelText: "Hospital",
          ),
          onChanged: (HospitalModel value) {
            hospitalDropDownValue = value;
            selectedHospitalId = value.hospitalId;
          },
          value: hospitalDropDownValue,
          items: [
            for (int i = 0; i < hospitalList.length; i++)
              DropdownMenuItem(
                child: Text(hospitalList[i].hospitalName),
                value: hospitalList[i],
              ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: doctorDepartmentController,
            onChanged: (value) {
              setState(() {
                doctorDepartmentErrorMsg =
                    (value == "") ? "Please enter Doctor's Department" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Department"),
            minLines: 2,
            maxLines: 2,
          ),
        ),
        errorMsgWidget(doctorDepartmentErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: doctorPhoneController,
            onChanged: (value) {
              setState(() {
                doctorPhoneErrorMsg =
                    (value == "") ? "Please enter Doctor's Phone Number" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Phone Number"),
          ),
        ),
        errorMsgWidget(doctorPhoneErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: doctorEmailController,
            onChanged: (value) {
              setState(() {
                doctorEmailErrorMsg =
                    (value == "") ? "Please enter Doctor's Email Address" : "";

                String email = value;
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(email);
                doctorEmailErrorMsg = (!emailValid)
                    ? "Please enter Valid Doctor's Email Address"
                    : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Email Address"),
          ),
        ),
        errorMsgWidget(doctorEmailErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: doctorPasswordController,
            onChanged: (value) {
              setState(() {
                doctorPasswordErrorMsg =
                    (value == "") ? "Please enter Password" : "";
                if (value.length < 8)
                  doctorPasswordErrorMsg =
                      "Please Enter minimum 8 Letters or Number";
              });
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.darkBlue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.linkBlue, width: 1),
              ),
              labelText: "Password",
              suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisibility ? MdiIcons.eyeOff : MdiIcons.eye,
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
        errorMsgWidget(doctorPasswordErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: doctorConfirmPasswordController,
            onChanged: (value) {
              setState(() {
                if (value == "")
                  doctorConfirmPasswordErrorMsg =
                      "Please enter Confirm Password";

                doctorConfirmPasswordErrorMsg =
                    (value != doctorPasswordController.text)
                        ? "Password and Confirm Password must be match"
                        : "";
              });
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.darkBlue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.linkBlue, width: 1),
              ),
              labelText: "Confirm Password",
              suffixIcon: IconButton(
                icon: Icon(
                  confirmPasswordVisibility ? MdiIcons.eyeOff : MdiIcons.eye,
                ),
                onPressed: () {
                  setState(() {
                    confirmPasswordVisibility = !confirmPasswordVisibility;
                  });
                },
              ),
            ),
            obscureText: confirmPasswordVisibility,
          ),
        ),
        errorMsgWidget(doctorConfirmPasswordErrorMsg),
      ],
    );
  }
}

/// HOSPITAL SIGN UP
TextEditingController hospitalNameController = TextEditingController();
TextEditingController hospitalAddressController = TextEditingController();
TextEditingController hospitalPhoneController = TextEditingController();
TextEditingController hospitalEmailController = TextEditingController();
TextEditingController hospitalPasswordController = TextEditingController();
TextEditingController hospitalConfirmPasswordController =
    TextEditingController();
String hospitalNameErrorMsg = "";
String hospitalAddressErrorMsg = "";
String hospitalPhoneErrorMsg = "";
String hospitalEmailErrorMsg = "";
String hospitalPasswordErrorMsg = "";
String hospitalConfirmPasswordErrorMsg = "";

class SignUpScreenHospital extends StatefulWidget {
  @override
  _SignUpScreenHospitalState createState() => _SignUpScreenHospitalState();
}

class _SignUpScreenHospitalState extends State<SignUpScreenHospital> {
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 58,
          child: TextField(
            controller: hospitalNameController,
            onChanged: (value) {
              setState(() {
                hospitalNameErrorMsg =
                    (value == "") ? "Please enter Hospital's Name" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Hospital Name"),
          ),
        ),
        errorMsgWidget(hospitalNameErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: hospitalAddressController,
            onChanged: (value) {
              setState(() {
                hospitalAddressErrorMsg =
                    (value == "") ? "Please enter Hospital's Address" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Address"),
            minLines: 2,
            maxLines: 2,
          ),
        ),
        errorMsgWidget(hospitalAddressErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: hospitalPhoneController,
            onChanged: (value) {
              setState(() {
                hospitalPhoneErrorMsg =
                    (value == "") ? "Please enter Hospital's Phone Number" : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Phone Number"),
          ),
        ),
        errorMsgWidget(hospitalPhoneErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: hospitalEmailController,
            onChanged: (value) {
              setState(() {
                hospitalEmailErrorMsg = (value == "")
                    ? "Please enter Hospital's Email Address"
                    : "";

                String email = value;
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(email);
                hospitalEmailErrorMsg = (!emailValid)
                    ? "Please enter Valid Hospital's Email Address"
                    : "";
              });
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.darkBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Style.linkBlue, width: 1),
                ),
                labelText: "Email Address"),
          ),
        ),
        errorMsgWidget(hospitalEmailErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: hospitalPasswordController,
            onChanged: (value) {
              setState(() {
                hospitalPasswordErrorMsg =
                    (value == "") ? "Please enter Password" : "";
                if (value.length < 8)
                  hospitalPasswordErrorMsg =
                      "Please Enter minimum 8 Letters or Number";
              });
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.darkBlue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.linkBlue, width: 1),
              ),
              labelText: "Password",
              suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisibility ? MdiIcons.eyeOff : MdiIcons.eye,
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
        errorMsgWidget(hospitalPasswordErrorMsg),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 58,
          child: TextField(
            controller: hospitalConfirmPasswordController,
            onChanged: (value) {
              setState(() {
                if (value == "")
                  hospitalConfirmPasswordErrorMsg =
                      "Please enter Confirm Password";

                hospitalConfirmPasswordErrorMsg =
                    (value != hospitalPasswordController.text)
                        ? "Password and Confirm Password must be match"
                        : "";
              });
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.darkBlue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Style.linkBlue, width: 1),
              ),
              labelText: "Confirm Password",
              suffixIcon: IconButton(
                icon: Icon(
                  confirmPasswordVisibility ? MdiIcons.eyeOff : MdiIcons.eye,
                ),
                onPressed: () {
                  setState(() {
                    confirmPasswordVisibility = !confirmPasswordVisibility;
                  });
                },
              ),
            ),
            obscureText: confirmPasswordVisibility,
          ),
        ),
        errorMsgWidget(hospitalConfirmPasswordErrorMsg),
      ],
    );
  }
}

Widget errorMsgWidget(String message) => Align(
      alignment: Alignment.centerLeft,
      child: Text(
        message,
        textAlign: TextAlign.start,
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
