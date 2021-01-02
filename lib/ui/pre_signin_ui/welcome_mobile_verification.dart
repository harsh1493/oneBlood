import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/bussiness_logic/services/otp_service.dart';
import 'package:one_blood/data/country_flags.dart';
import 'package:one_blood/data/otp_generator.dart';

import 'otp_verification_ui.dart';

class MobileVerification extends StatefulWidget {
  static const String id = 'mobile_verification';
  @override
  _MobileVerificationState createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  TextEditingController _form = TextEditingController();
  String countryCode = '+91';

  @override
  void initState() {
    Firebase.initializeApp();
    // TODO: implement initState
    _form.text = '8962372084';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(97, 57, 58, 0.8),
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, top: 100, right: 15, bottom: 50),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    width: double.infinity,
                    //height: 200,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 80, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Welcome to OneBlood',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Norican'),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text('Sign up/Login to your account',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Norican')),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                //color: Colors.grey,
                                onTap: () {
                                  print('select country');
                                  buildShowModalBottomSheet(context);
                                },
                                hoverColor: Colors.red,
                                splashColor: Colors.black,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.blue),
                                    color: Color.fromRGBO(21, 251, 251, 1),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        countryCode,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down_rounded,
                                        size: 25,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextFormField(
                                  maxLengthEnforced: false,
                                  controller: _form,
                                  style: TextStyle(color: Colors.black),
                                  decoration: new InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    hintText: 'Enter your phone number',
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    fillColor: Color.fromRGBO(21, 251, 251, 1),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.red)),
                            color: Colors.redAccent,
                            textColor: Colors.red,
                            splashColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {
                              String otpNumber = getOTP();
                              OtpService().sendOTP(
                                  otpNumber: otpNumber,
                                  countryCode: countryCode,
                                  phoneNumber: _form.text);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpVerificationUI(
                                          phoneNumber: _form.text,
                                          otp: otpNumber,
                                        )),
                              );
                            },
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'By clicking continue you agree to the Terms of Service and Privacy Policy',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 1,
                                color: Colors.black,
                              ),
                              Text(
                                ' OR CONNECT WITH ',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 12),
                              ),
                              Container(
                                width: 80,
                                height: 1,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RawMaterialButton(
                                onPressed: () {
                                  AuthServices()
                                      .googleSignIn(context, true)
                                      .then((User user) => print(user))
                                      .catchError((e) => print(e));
                                },
                                elevation: 10.0,
                                fillColor: Colors.red,
                                child: Icon(
                                  FontAwesomeIcons.google,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                onPressed: () {},
                                elevation: 10.0,
                                fillColor: Color.fromRGBO(45, 117, 232, 1),
                                child: Icon(
                                  FontAwesomeIcons.facebookF,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 150,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromRGBO(97, 57, 58, 0.8),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Image(
                    image: AssetImage('assets/oneBloodRed.png'),
                    width: 70,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context) {
    List<Map> countriesShort2 = codes;
    print(countriesShort2);

    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      isScrollControlled: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => DraggableScrollableSheet(
//             initialChildSize: 0.1,
//             minChildSize: 0.2,
//             maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Search your country'),
            ),
            body: Container(
              child: ListView.builder(
                controller: scrollController,
                itemCount: 256,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print(countriesShort2[index]);
                      setState(() {
                        countryCode =
                            countriesShort2[index]['dial_code'].toString();
                        Navigator.pop(context);
                      });
                    },
                    child: ListTile(
                      leading: Image(
                        image: AssetImage(
                            'assets/flags/${countriesShort2[index]['code'].toLowerCase()}.png'),
                        width: 40,
                      ),
                      title: Text(countriesShort2[index]['name']),
                      trailing:
                          Text(countriesShort2[index]['dial_code'].toString()),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
