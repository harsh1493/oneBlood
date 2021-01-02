import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/helperUI/background_painter.dart';
import 'package:one_blood/helperUI/progress_bar.dart';
import 'package:one_blood/homePage/home_page_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/welcome_mobile_verification.dart';

class LoginUI extends StatefulWidget {
  static const String id = 'login_ui';
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  AnimationController _controller;
  TextEditingController _email =
      new TextEditingController(text: 'abc@gmail.com');
  TextEditingController _password = new TextEditingController(text: '123456');
  var errorMessageEmail;
  var errorMessagePassword;
  bool emailErrorExists = true;
  bool passwordErrorExists = true;
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool hidden = true;
  bool showProgress = false;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // TODO: implement initState
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        //constraints: BoxConstraints(maxWidth: 230.0, maxHeight: 25.0),
        color: Colors.white,
        //color: Colors.white,
        child: Container(
          child: Stack(children: [
            SizedBox.expand(
              child: CustomPaint(
                painter: BackgroundPainter(
                  animation: _controller,
                ),
              ),
            ),
            Container(
              //color: Colors.white10,
              child: ListView(
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 50,
                          bottom: 100,
                          top: 80,
                        ),
                        child: Text(
                          'Welcome Back!',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      )),
                  Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'USERNAME',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                            TextFormField(
                              controller: _email,
                              maxLengthEnforced: false,
                              onChanged: (value) {
                                // email = value;

                                setState(() {
                                  _email.text.isEmpty
                                      ? _validateEmail = true
                                      : _validateEmail = false;
                                  emailErrorExists = !RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(_email.text);
                                });
                              },
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              decoration: new InputDecoration(
                                suffixIcon: Visibility(
                                  visible:
                                      !_validateEmail && _email.text.length > 0,
                                  child: Icon(
                                    emailErrorExists
                                        ? FontAwesomeIcons.exclamation
                                        : Icons.check,
                                    size: emailErrorExists ? 15 : 25,
                                    color: emailErrorExists
                                        ? Colors.red
                                        : Colors.blue,
                                  ),
                                ),
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                errorText: _validateEmail
                                    ? 'Email Can\'t Be Empty'
                                    : errorMessageEmail,
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                ),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                ),
                                // border: OutlineInputBorder(),
                                // labelText: 'Email',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'PASSWORD',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                            TextFormField(
                              controller: _password,
                              maxLengthEnforced: false,
                              onChanged: (value) {
                                //Do something with the user input.
                                //password = value;
                                _password.text.isEmpty
                                    ? _validatePassword = true
                                    : _validatePassword = false;

                                setState(() {
                                  _password.text.length >= 6
                                      ? passwordErrorExists = true
                                      : passwordErrorExists = false;
                                });
                              },
                              style: TextStyle(color: Colors.blue),
                              cursorColor: Colors.black,
                              obscureText: hidden ? true : false,
                              decoration: new InputDecoration(
                                errorText: _validatePassword
                                    ? 'Password Can\'t Be Empty'
                                    : passwordErrorExists
                                        ? errorMessagePassword
                                        : null,
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                suffixIcon: Wrap(children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Visibility(
                                      visible: !_validatePassword &&
                                          _password.text.length > 0,
                                      child: Icon(
                                        !passwordErrorExists
                                            ? FontAwesomeIcons.exclamation
                                            : Icons.check,
                                        size: !passwordErrorExists ? 15 : 25,
                                        color: !passwordErrorExists
                                            ? Colors.red
                                            : Colors.blue,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        !hidden
                                            ? Icons.remove_red_eye
                                            : FontAwesomeIcons.solidEyeSlash,
                                        size: !hidden ? 20 : 15,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          hidden = !hidden;
                                        });
                                      }),
                                ]),
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 20),
                                  child: Text('Forgot password?'),
                                )),
                            SignInBar(
                                label: 'Sign In',
                                isLoading: showProgress,
                                // onPressed: () async {
                                //   setState(() {
                                //     showProgress = !showProgress;
                                //     Timer(Duration(seconds: 2), () {
                                //       Navigator.pushNamed(
                                //           context, HomePageUi.id);
                                //     });
                                //   });
                                // }
                                onPressed: () async {
                                  //Implement registration functionality.
                                  setState(() {
                                    showProgress = true;
                                  });
                                  try {
                                    final newUser =
                                        await _auth.signInWithEmailAndPassword(
                                            email: _email.text,
                                            password: _password.text);

                                    if (newUser != null) {
                                      Navigator.pushNamed(
                                          context, HomePageUi.id);
                                    }
                                    setState(() {
                                      showProgress = false;
                                      //passwordErrorExists = false;
                                    });
                                  } catch (error) {
                                    //print('Exception :$error');
                                    setState(() {
                                      showProgress = false;
                                    });
                                    print('Error:${error.hashCode}');
                                    print(error);
                                    setState(() {
                                      if (error.hashCode == 218430393) {
                                        errorMessagePassword =
                                            'Invalid password';
                                        passwordErrorExists = true;
                                      }
                                      if (error.hashCode == 246276089) {
                                        errorMessageEmail = 'User not found';
                                        emailErrorExists = true;
                                      }
                                      if (error.hashCode == 540662271) {
                                        errorMessageEmail =
                                            'The email address is badly formatted.';
                                        emailErrorExists = true;
                                      }
                                      if (error.hashCode == 294110625) {
                                        errorMessagePassword =
                                            'Password is required';
                                        passwordErrorExists = true;
                                      }
                                      if (error.hashCode != 540662271 &&
                                              error.hashCode != 246276089 ||
                                          error.hashCode == 849834254) {
                                        errorMessageEmail = '';
                                        emailErrorExists = false;
                                      }
                                      if (error.hashCode != 294110625 &&
                                          error.hashCode != 218430393) {
                                        errorMessagePassword = '';
                                      }
                                    });
                                  }
                                }),
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
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Container(
                                  width: 80,
                                  height: 1,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    AuthServices()
                                        .googleSignIn(context, false)
                                        .then((User user) => print(user))
                                        .catchError((e) => print(e));
                                  },
                                  elevation: 2.0,
                                  fillColor: Colors.red,
                                  child: Icon(
                                    FontAwesomeIcons.google,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 2.0,
                                  fillColor: Color.fromRGBO(45, 117, 232, 1),
                                  child: Icon(
                                    FontAwesomeIcons.facebookF,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                RawMaterialButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, MobileVerification.id);
                                  },
                                  elevation: 2.0,
                                  fillColor: Color.fromRGBO(50, 82, 167, 1),
                                  child: Icon(
                                    FontAwesomeIcons.mobileAlt,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
