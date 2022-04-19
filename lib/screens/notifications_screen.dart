import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(top: 68, right: 12),
          child: SizedBox(
              width: 380,
              height: 460,
              child: Material(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                      padding: EdgeInsets.all(18),
                      child: ListView(children: [
                        Row(
                          children: [
                            Text(
                              'Notifications',
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
                          height: 6,
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Event #1 title'),
                          subtitle: Text('* date *'),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ])))),
        ));
  }
}
