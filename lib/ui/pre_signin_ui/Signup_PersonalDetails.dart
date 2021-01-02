import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/bussiness_logic/services/location.dart';
import 'package:one_blood/constants.dart';
import 'package:one_blood/homePage/home_page_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/welcome_ui.dart';
import 'package:shimmer/shimmer.dart';

class PersonalDetails extends StatefulWidget {
  static const String id = 'signUp_PersonalDetails';
  final email;
  PersonalDetails({@required this.email});
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  List<Widget> bloodGroupWidgets = [];
  Gender _gender = Gender.male;
  Choice _choice = Choice.no;
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _postalAddress = new TextEditingController();
  bool isFetchingLocation = false;
  double _weight = 50.00;
  // String bloodGroup = 'Select Blood Group';
  String bloodGroup;
  String _value = '';
  DateTime dob;
  bool errorVis = false;
  GeoPoint coordinates;
  String _city;
  Map<String, dynamic> location;
  Future _selectDate() async {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1980),
      lastDate: new DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _value = formatter.format(picked);
        dob = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _email.text = widget.email;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(b.values.toList());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    onPressed: () {
                      AuthServices().googleSignOut();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 50),
                  child: Text(
                    'Enter Personal Details',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                        child: TextFormField(
                          maxLengthEnforced: false,
                          onChanged: (value) {
                            print(value);
                            setState(() {});
                          },
                          controller: _firstName,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                            errorText: _firstName.text.isEmpty && errorVis
                                ? '*first name required'
                                : null,
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                            hintText: 'First Name',
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
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                        child: TextFormField(
                          maxLengthEnforced: false,
                          onChanged: (value) {
                            print(value);
                            setState(() {});
                          },
                          controller: _lastName,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                            errorText: _lastName.text.isEmpty && errorVis
                                ? '*last name required'
                                : null,
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                            hintText: 'Last Name',
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
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Gender :',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Radio(
                        activeColor: Colors.red,
                        focusColor: Colors.red,
                        value: Gender.male,
                        groupValue: _gender,
                        onChanged: (Gender value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      Text(
                        'Male',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Radio(
                        activeColor: Colors.red,
                        value: Gender.female,
                        groupValue: _gender,
                        onChanged: (Gender value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      Text(
                        'Female',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Radio(
                        activeColor: Colors.red,
                        value: Gender.other,
                        groupValue: _gender,
                        onChanged: (Gender value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      Text(
                        'Other',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromRGBO(21, 251, 251, 1),
                              border: Border.all()),
                          child: DropdownButton<String>(
                            dropdownColor: Color.fromRGBO(21, 251, 251, 1),
                            autofocus: true,
                            value: bloodGroup,
                            icon: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.black,
                              size: 25,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            hint: Text(
                              'Select Blood Group',
                              style: TextStyle(fontSize: 15),
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (String newValue) {
                              setState(() {
                                bloodGroup = newValue;
                              });
                            },
                            underline: Container(
                              height: 4,
                              color: Color.fromRGBO(21, 251, 251, 1),
                            ),
                            items: b.values
                                .toList()
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromRGBO(21, 251, 251, 1),
                              border: Border.all()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  _value == '' ? 'Date of Birth' : _value,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: _value == ''
                                          ? Colors.black45
                                          : Colors.black),
                                ),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: InkWell(
                                      child: Icon(
                                        FontAwesomeIcons.calendarAlt,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        print('date');
                                        _selectDate();
                                        print(_value);
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: errorVis,
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20, top: 10, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: bloodGroup == null,
                            child: Text(
                              '*Blood group required',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Visibility(
                            visible: _value == '',
                            child: Text(
                              '*dob required',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLengthEnforced: false,
                          onChanged: (value) {
                            print(value);
                            setState(() {});
                          },
                          controller: _email,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                            errorText: _email.text.isEmpty && errorVis
                                ? 'Email address is required'
                                : !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(_email.text) &&
                                        errorVis
                                    ? 'Email is badly formatted'
                                    : null,
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                            hintText: 'Enter your email id',
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
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                              child: Icon(
                                Icons.mail,
                                color: Colors.white,
                              ),
                              onTap: () {
                                print('mail id');
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLengthEnforced: false,
                          onChanged: (value) {
                            print(value);
                            setState(() {});
                          },
                          controller: _postalAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                            errorText: _postalAddress.text.isEmpty && errorVis
                                ? 'Postal address is required'
                                : null,
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                            hintText: 'Postal Address',
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
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                              child: Shimmer.fromColors(
                                baseColor: isFetchingLocation
                                    ? Colors.black
                                    : Colors.white,
                                highlightColor: isFetchingLocation
                                    ? Colors.yellow
                                    : Colors.white,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () async {
                                print('location');
                                setState(() {
                                  isFetchingLocation = true;
                                });

                                location =
                                    await Location.reverseGeocodedLocation();

                                setState(() {
                                  isFetchingLocation = false;
                                  _postalAddress.text =
                                      location["display_name"];
                                  _city = location["address"]["city"];
                                });
                                coordinates = await Location.getLocation();
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 30, top: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.weight,
                            color: Colors.red,
                            size: 20,
                          ),
                          Text(
                            '   Weight',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Spacer(),
                          Text(_weight.round().toString() + ' kgs',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))
                        ],
                      ),
                      Slider(
                        value: _weight,
                        min: 40,
                        max: 110,
                        divisions: 70,
                        activeColor: Colors.red,
                        label: _weight.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _weight = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 20, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Have you suffered from Covid19 in past?',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.red,
                            focusColor: Colors.red,
                            value: Choice.yes,
                            groupValue: _choice,
                            onChanged: (Choice value) {
                              setState(() {
                                _choice = value;
                              });
                            },
                          ),
                          Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Radio(
                            activeColor: Colors.red,
                            focusColor: Colors.red,
                            value: Choice.no,
                            groupValue: _choice,
                            onChanged: (Choice value) {
                              setState(() {
                                _choice = value;
                              });
                            },
                          ),
                          Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 20, top: 15),
                  child: Container(
                    height: 0.5,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FlatButton(
                    minWidth: double.infinity,
                    color: Colors.redAccent,
                    textColor: Colors.red,
                    splashColor: Colors.black,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    onPressed: () async {
                      setState(() {
                        errorVis = true;
                      });

                      if (validateForm()) {
                        User user = User(
                            uid: AuthServices().user.uid,
                            wannaDonate: false,
                            userName: _firstName.text + " " + _lastName.text,
                            phoneNumber: null,
                            gender: _gender.toString(),
                            address: _postalAddress.text,
                            location: location,
                            email: _email.text,
                            covid: _choice.toString() == 'yes' ? true : false,
                            bloodGroup: bloodGroup.toString(),
                            coordinates: coordinates,
                            weight: _weight.round(),
                            city: _city,
                            dob: dob);
                        await AuthServices().setUserProfile(
                            userName: user.userName, photoUrl: null);
                        await AuthServices().updateEmail(email: user.email);
                        try {
                          await DatabaseHandler().addUser(user);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePageUi()),
                          );
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        return;
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateForm() {
    if (_firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        bloodGroup == null ||
        _value == '' ||
        _email.text.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_email.text) ||
        _postalAddress.text.isEmpty) {
      return false;
    }

    return true;
  }
}
