import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meddashboard/screens/getting_started/sign_up.dart';
import 'package:meddashboard/service/api/hospitals.dart';
import 'package:meddashboard/service/models/hopital_model.dart';
import 'package:meddashboard/utils/app_preference.dart';
import '../../main.dart';
import '../main_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool keepMeLoggedIn = false;
  TextEditingController loginC;
  TextEditingController passwordC;

  @override
  void initState() {
    loginC = TextEditingController();
    passwordC = TextEditingController();
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
                      width: 400,
                      height: 58,
                      child: TextField(
                        controller: loginC,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Style.darkBlue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Style.linkBlue, width: 1),
                            ),
                            labelText: "Username"),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 400,
                      height: 58,
                      child: TextField(
                        controller: passwordC,
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
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: 400,
                      child: Row(
                        children: [
                          Checkbox(
                              value: keepMeLoggedIn,
                              onChanged: (v) =>
                                  setState(() => keepMeLoggedIn = v)),
                          Text('Keep me logged in'),
                          Spacer(),
                          FlatButton(
                              onPressed: () {},
                              child: Text('Reset password',
                                  style: GoogleFonts.firaMono()))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Builder(
                      builder: (_) => Material(
                        color: Style.darkBlue,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () async {
                            String sspd = await HospitalLogin.hospitallogin(
                              loginC.text,
                              passwordC.text,
                            );
                            if (sspd == 'not') {
                              ScaffoldMessenger.of(_).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Email does not Exist, Please enter valid Username."),
                                ),
                              );
                              return;
                            }
                            if (sspd == 'Password incorrect') {
                              ScaffoldMessenger.of(_).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Password is Incorrect, Please enter valid Password.'),
                                ),
                              );
                              return;
                            }
                            if (sspd == 'Success') {
                              HospitalModel hospital = await APIHospitals.getHospitalId(loginC.text);
                              AppPreference.put("hospitalId", hospital.hospitalId);
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => MainScreen(hospital),),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 48,
                            width: 260,
                            child: Center(
                                child: Text(
                              'Sign In',
                              style: GoogleFonts.montserrat(
                                  color: Style.white, fontSize: 18),
                            )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => SignUpScreen()));
                        },
                        child: Text('Sign Up', style: GoogleFonts.firaMono())),
                  ],
                ),
              ),
            )));
  }
}
