import 'package:flutter/material.dart';
import 'package:one_blood/helperUI/otpForm.dart';
import 'package:one_blood/ui/pre_signin_ui/signup_ui.dart';

import 'Signup_PersonalDetails.dart';

String otpNumber = '';
bool isOtpCorrect = true;

class OtpVerificationUI extends StatefulWidget {
  static const String id = 'otp_verification';
  final otp;
  final phoneNumber;
  OtpVerificationUI({@required this.phoneNumber, @required this.otp});
  @override
  _OtpVerificationUIState createState() => _OtpVerificationUIState();
}

class _OtpVerificationUIState extends State<OtpVerificationUI>
    with SingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  bool hasError = false;
  AnimationController controller;

  void notify() {
    setState(() {});
  }

  @override
  void initState() {
    otpNumber = widget.otp;
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });

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
                              'Verify',
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
                          Text(
                              'Please enter verification code (OTP) sent to:\n ${widget.phoneNumber}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Norican')),
                          SizedBox(
                            height: 30,
                          ),
                          AnimatedBuilder(
                              animation: offsetAnimation,
                              builder: (buildContext, child) {
                                return Container(
                                    padding: EdgeInsets.only(
                                        left: offsetAnimation.value + 26.0,
                                        right: 26.0 - offsetAnimation.value),
                                    child: OtpForm(
                                      otpLength: 6,
                                      otp: widget.otp,
                                      notify: notify,
                                    ));
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Resend',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          FlatButton(
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.red)),
                            color: Colors.black54,
                            textColor: Colors.red,
                            splashColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {
                              setState(() {});
                              if (!isOtpCorrect)
                                controller.forward(from: 0.0);
                              else {
                                print(otpNumber);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupUI()),
                                );
                              }
                            },
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 50,
                  left: offsetAnimation.value + 150.0,
                  right: 124.0 - offsetAnimation.value),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromRGBO(97, 57, 58, 0.8),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  //backgroundImage: AssetImage('assets/otp.png'),
                  child: Image(
                    image: AssetImage('assets/otp.png'),
                    width: 70,
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
