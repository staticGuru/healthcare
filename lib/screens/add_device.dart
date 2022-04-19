import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meddashboard/fragments/group.dart';
import 'package:meddashboard/main.dart';
import 'package:meddashboard/screens/main_screen.dart';
import 'package:meddashboard/service/api/device.dart';
import 'package:meddashboard/service/models/device_model.dart';

class DeviceScreen extends StatefulWidget {
  final String patientId;
  final String hospitalId;
  final BuildContext ctx;

  DeviceScreen(this.patientId, this.ctx, this.hospitalId);

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final TextEditingController deviceSerialNumberController =
      TextEditingController();

  List<String> deviceType = ["ECG", "PPG"];

  String deviceTypeDropDownValue = "ECG";

  String deviceSerialNumberErrorMsg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 420,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Add Device',
                      style: GoogleFonts.poppins(
                        color: Style.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(widget.ctx),
                      icon: Icon(MdiIcons.close),
                    ),
                  ],
                ),
                TextField(
                  controller: deviceSerialNumberController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Style.darkBlue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Style.linkBlue, width: 1),
                    ),
                    labelText: "Device Serial Number",
                    errorText: deviceSerialNumberErrorMsg,
                  ),
                  onChanged: (value) {
                    setState(() {
                      deviceSerialNumberErrorMsg = (value.isEmpty)
                          ? "Please enter Device Serial Number"
                          : null;
                    });
                  },
                ),
                SizedBox(
                  height: 18,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Style.darkBlue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Style.linkBlue, width: 1),
                    ),
                    labelText: "Device Type",
                  ),
                  icon: Icon(
                    MdiIcons.arrowDownDropCircle,
                    color: Style.darkBlue,
                  ),
                  onChanged: (value) {
                    deviceTypeDropDownValue = value;
                  },
                  value: deviceTypeDropDownValue,
                  items: [
                    DropdownMenuItem(
                      child: Text(deviceType[0]),
                      value: deviceType[0],
                    ),
                    DropdownMenuItem(
                      child: Text(deviceType[1]),
                      value: deviceType[1],
                    ),
                  ],
                ),
                SizedBox(height: 18.0),
                Material(
                  color: Style.darkBlue,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () async {
                      if (deviceSerialNumberController.text.isEmpty) {
                        setState(() {
                          deviceSerialNumberErrorMsg =
                              "Please enter Device Serial Number";
                        });
                      } else {
                        MainScreen.allPatients.forEach((element) {
                          if (element.patientId == widget.patientId)
                            element.patient.devices.add(
                              DeviceModel(
                                deviceSerialNumber:
                                    deviceSerialNumberController.text,
                                deviceType: (deviceTypeDropDownValue == "ECG")
                                    ? "1"
                                    : "2",
                                patientId: widget.patientId,
                              ),
                            );
                        });
                        GroupFragment.getPatient();
                        await AddDevice.addDevice(
                          DeviceModel(
                            battery: '0',
                            deviceSerialNumber: deviceSerialNumberController.text,
                            deviceType: (deviceTypeDropDownValue == "ECG") ? "1" : "2",
                            patientId: widget.patientId,
                          ),
                        );
                        Navigator.pop(widget.ctx);

                        // ApiPatient.getAllPatient(widget.hospitalId);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 48,
                      width: 260,
                      child: Center(
                        child: Text(
                          'Add Device',
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
