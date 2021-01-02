import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:one_blood/helperUI/background_painter.dart';
import 'package:one_blood/ui/pre_signin_ui/otp_verification_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/signup_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/welcome_mobile_verification.dart';

import 'login_ui.dart';

class WelcomeUi extends StatefulWidget {
  static const String id = 'welcome_ui';
  @override
  _WelcomeUiState createState() => _WelcomeUiState();
}

class _WelcomeUiState extends State<WelcomeUi>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // TODO: implement initState
    // _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.reverse();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.redAccent,
        child: Stack(children: [
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: _controller,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 1,
                        child: Image(
                          image: AssetImage('assets/oneBloodRed.png'),
                          width: 150,
                          height: 150,
                        ),
                      ),
                      Text(
                        'oneBlood',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            fontFamily: 'Limelight'),
                      )
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.white)),
                            color: Colors.transparent,
                            textColor: Colors.red,
                            splashColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {
                              // Navigator.pushNamed(
                              //     context, MobileVerification.id);
                              Navigator.pushNamed(context, SignupUI.id);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(140, 10, 140, 10),
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.white)),
                            color: Colors.white,
                            splashColor: Colors.grey,
                            textColor: Colors.red,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {
                              _controller.forward();
                              Navigator.pushNamed(context, LoginUI.id);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(140, 10, 140, 10),
                              child: Text(
                                'LOG IN',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
