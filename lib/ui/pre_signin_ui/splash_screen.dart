import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'onboarding_page.dart';

class SplashScreen1 extends StatefulWidget {
  static const String id = 'splash_screen';
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1>
    with SingleTickerProviderStateMixin {
  bool visible = false;
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(milliseconds: 200), () {
      setState(() {
        visible = true;
      });
    });
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pushNamed(context, OnboardingPage.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
        ),
        child: Container(
          color: Color.fromRGBO(97, 57, 58, 0.8),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Expanded(
                flex: 2,
                child: FlareActor("assets/blood2white.flr",
                    color: Colors.blue,
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.contain,
                    animation: "Untitled"),
              ),
              Expanded(
                flex: 3,
                child: AnimatedOpacity(
                  opacity: visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 1000),
                  child: Text(
                    'oneBlood',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'Limelight'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
