import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:one_blood/helperUI/background_painter.dart';
import 'package:one_blood/helperUI/progress_bar.dart';
import 'Signup_PersonalDetails.dart';

class SignupUI extends StatefulWidget {
  static const String id = 'signup_ui';
  @override
  _SignupUIState createState() => _SignupUIState();
}

class _SignupUIState extends State<SignupUI>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  AnimationController _controller;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  var errorMessageEmail;
  var errorMessagePassword;
  bool emailErrorExists = true;
  bool passwordErrorExists = true;
  bool confirmPasswordErrorExists = true;
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _validateConfirmPassword = false;
  bool hidden = true;
  bool hiddenC = true;
  bool showSpinner = false;
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
      body: Builder(
        builder: (context) => DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
          ),
          child: Container(
            //constraints: BoxConstraints(maxWidth: 230.0, maxHeight: 25.0),
            color: Colors.white,
            //color: Colors.white,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: CustomPaint(
                    painter: BackgroundPainter(
                      animation: _controller,
                    ),
                  ),
                ),
                ListView(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 50, bottom: 80, top: 50),
                          child: Text(
                            'Create An Account',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        )),
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
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
                                onChanged: (value) {
                                  // email = value;

                                  setState(() {
                                    _validateEmail = _email.text.isEmpty;

                                    emailErrorExists = !RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(_email.text);
                                    errorMessageEmail = emailErrorExists
                                        ? 'Invalid email format'
                                        : '';
                                  });
                                },
                                maxLengthEnforced: false,
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.black,
                                decoration: new InputDecoration(
                                  suffixIcon: Visibility(
                                    visible: !_validateEmail &&
                                        _email.text.length > 0,
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
                                    color: Colors.black,
                                  ),
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
                                maxLengthEnforced: false,
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.black,
                                obscureText: hidden ? true : false,
                                decoration: new InputDecoration(
                                  errorText: _validatePassword
                                      ? 'Password Can\'t Be Empty'
                                      : passwordErrorExists
                                          ? errorMessagePassword
                                          : null,
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
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'CONFIRM PASSWORD',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                              TextFormField(
                                controller: _confirmPassword,
                                onChanged: (value) {
                                  setState(() {
                                    _validateConfirmPassword =
                                        _confirmPassword.text.length > 0;
                                    confirmPasswordErrorExists =
                                        _password.text != _confirmPassword.text;
                                  });
                                },
                                maxLengthEnforced: false,
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.black,
                                obscureText: hiddenC,
                                decoration: new InputDecoration(
                                  errorText: confirmPasswordErrorExists &&
                                          _validateConfirmPassword
                                      ? 'Passwords are not matching'
                                      : null,
                                  suffixIcon: Wrap(children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Visibility(
                                        visible:
                                            _confirmPassword.text.length > 0,
                                        child: Icon(
                                          confirmPasswordErrorExists
                                              ? FontAwesomeIcons.exclamation
                                              : Icons.check,
                                          size: confirmPasswordErrorExists
                                              ? 15
                                              : 25,
                                          color: confirmPasswordErrorExists
                                              ? Colors.red
                                              : Colors.blue,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          !hiddenC
                                              ? Icons.remove_red_eye
                                              : FontAwesomeIcons.solidEyeSlash,
                                          size: !hiddenC ? 20 : 15,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            hiddenC = !hiddenC;
                                          });
                                        }),
                                  ]),
                                  hintText: 'Enter your password again',
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SignUpBar(
                                  label: 'Continue',
                                  isLoading: showProgress,
                                  onPressed: () async {
                                    if (_password.text ==
                                        _confirmPassword.text) {
                                      setState(() {
                                        showProgress = true;
                                      });
                                      try {
                                        final newUser = await _auth
                                            .createUserWithEmailAndPassword(
                                                email: _email.text,
                                                password: _password.text);

                                        if (newUser != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PersonalDetails(
                                                      email: _auth
                                                          .currentUser.email,
                                                    )),
                                          );
                                          errorMessagePassword = '';
                                          errorMessageEmail = '';
                                        }
                                        setState(() {
                                          showProgress = false;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          showProgress = false;
                                          if (e.hashCode == 328678433) {
                                            errorMessagePassword =
                                                'Password should be at least 6 characters';
                                            passwordErrorExists = true;
                                          }
                                          if (e.hashCode == 86194409) {
                                            errorMessageEmail =
                                                'The email address is already in use by another account.';
                                            emailErrorExists = true;
                                          }
                                          if (e.hashCode == 889654280) {
                                            errorMessagePassword =
                                                'Enter password';
                                            passwordErrorExists = true;
                                          }
                                        });
                                        print(e);
                                        print(e.hashCode);
                                      }
                                    } else {
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text(
                                              'Passwords are not matching')));
                                    }
                                  })
                            ],
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
