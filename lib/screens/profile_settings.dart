import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

class ProfileSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 420,
            height: 450,
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
                                'Profile Settings',
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
                                  CheckboxListTile(
                                    value: true,
                                    onChanged: (_) {},
                                    title: Text('ECG'),
                                  ),
                                  CheckboxListTile(
                                    value: true,
                                    onChanged: (_) {},
                                    title: Text('Heart Rate'),
                                  ),
                                  CheckboxListTile(
                                    value: true,
                                    onChanged: (_) {},
                                    title: Text('Oxygen Level'),
                                  ),
                                  CheckboxListTile(
                                    value: true,
                                    onChanged: (_) {},
                                    title: Text('Lungs'),
                                  ),
                                  CheckboxListTile(
                                    value: true,
                                    onChanged: (_) {},
                                    title: Text('Temperature'),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Material(
                                    color: Style.darkBlue,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () {},
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
                        ])))));
  }
}
