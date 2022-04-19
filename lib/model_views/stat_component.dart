import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class StatComponent extends StatelessWidget {
  final String name;
  final String count;
  StatComponent({this.name, this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Style.accentBlue, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(color: Style.lineGray, fontSize: 18),
              ),
              Spacer(),
              Text(
                '54',
                style: GoogleFonts.firaMono(color: Style.bgBlue, fontSize: 24),
              ),
            ],
          )),
    );
  }
}
