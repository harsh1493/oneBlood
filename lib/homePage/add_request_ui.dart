import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/request.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/bussiness_logic/services/location.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cool_alert/cool_alert.dart';

import '../constants.dart';
import 'donor_list.dart';

class AddRequest extends StatefulWidget {
  static const String id = 'add_request';
  @override
  _AddRequestState createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  bool animate = false;
  String bloodGroup = '';
  int selected = 0;
  TextEditingController _patientName = new TextEditingController();
  bool isFetchingLocation = false;
  GeoPoint coordinates;
  String address;
  DateTime _date;
  String _dateFormatted;
  TimeOfDay _time;
  String _timeFormatted;
  double _units = 2;
  String _gender = 'male';
  String _relation = 'family';
  bool errorVis = false;
  var location;

  Future _selectDate() async {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1980),
      lastDate: new DateTime(
          DateTime.now().year, DateTime.now().month + 1, DateTime.now().day),
    );
    if (picked != null)
      setState(() {
        _dateFormatted = formatter.format(picked);
        _date = picked;
      });
  }

  Future _selectTime() async {
    TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (picked != null) {
      setState(() {
        _timeFormatted =
            localizations.formatTimeOfDay(picked, alwaysUse24HourFormat: false);
        _time = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      animate = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloodGroup = b.values.toList()[selected];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        shadowColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request For Blood',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Request for blood whenever wherever you need',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
        color: Colors.white,
        child: Material(
          color: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Choose Blood group',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: 65,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 5),
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            onTap: () {
                              setState(() {
                                selected = index;
                              });
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  gradient: selected == index
                                      ? LinearGradient(
                                          colors: [
                                            Color.fromRGBO(33, 31, 37, 0.5),
                                            Colors.red
                                          ],
                                          begin: FractionalOffset.topLeft,
                                          end: FractionalOffset.bottomRight,
                                        )
                                      : null,
                                ),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: Text(
                                    b.values.toList()[index],
                                    style: TextStyle(
                                        color: selected == index
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: 65,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 5),
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            onTap: () {
                              setState(() {
                                selected = index + 5;
                              });
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  gradient: selected == index + 5
                                      ? LinearGradient(
                                          colors: [
                                            Color.fromRGBO(33, 31, 37, 0.5),
                                            Colors.red
                                          ],
                                          begin: FractionalOffset.topLeft,
                                          end: FractionalOffset.bottomRight,
                                        )
                                      : null,
                                ),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: Text(
                                    b.values.toList()[index + 5],
                                    style: TextStyle(
                                        color: selected == index + 5
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 5, left: 5, right: 5),
                child: errorVis
                    ? address != null
                        ? Text(
                            'Location',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )
                        : Text(
                            '*Location',
                            style: TextStyle(fontSize: 13, color: Colors.red),
                          )
                    : Text(
                        'Location',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
              ),
              InkWell(
                onTap: () async {
                  print('location');
                  setState(() {
                    isFetchingLocation = true;
                  });
                  coordinates = await Location.getLocation();
                  location = await Location.reverseGeocodedLocation();

                  setState(() {
                    isFetchingLocation = false;
                    address = location["address"]["city"] +
                        ' ,' +
                        location['address']['postcode'] +
                        ' , ' +
                        location['address']['country'];
                  });
                },
                child: Card(
                  elevation: 10,
                  child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(address ?? 'Click to add address'),
                          Spacer(),
                          Shimmer.fromColors(
                              baseColor: isFetchingLocation
                                  ? Colors.black
                                  : Colors.red,
                              highlightColor: isFetchingLocation
                                  ? Colors.yellow
                                  : Colors.red,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ))
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 5, left: 5, right: 5),
                child: errorVis
                    ? _date != null
                        ? Text(
                            'Date',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )
                        : Text(
                            '*Date',
                            style: TextStyle(fontSize: 13, color: Colors.red),
                          )
                    : Text(
                        'Date',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
              ),
              InkWell(
                onTap: () {
                  print('date');
                  _selectDate();
                  print(_date);
                },
                child: Card(
                  elevation: 10,
                  child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_dateFormatted ?? 'Choose date'),
                          Spacer(),
                          Icon(
                            FontAwesomeIcons.calendarAlt,
                            size: 20,
                            color: Colors.red,
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 5, left: 5, right: 5),
                child: errorVis
                    ? _time != null
                        ? Text(
                            'Time',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )
                        : Text(
                            '*Time',
                            style: TextStyle(fontSize: 13, color: Colors.red),
                          )
                    : Text(
                        'Time',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
              ),
              InkWell(
                onTap: () {
                  print('time');
                  _selectTime();
                  print(_timeFormatted);
                },
                child: Card(
                  elevation: 10,
                  child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_timeFormatted ?? 'Choose time'),
                          Spacer(),
                          Icon(
                            FontAwesomeIcons.solidClock,
                            size: 20,
                            color: Colors.red,
                          )
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.drop_fill,
                          color: Colors.red,
                          size: 20,
                        ),
                        Text(
                          '   Blood units',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                            _units.toStringAsPrecision(3) +
                                ' pint' +
                                (_units > 1.0 ? 's' : ''),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ],
                    ),
                    Slider(
                      value: _units,
                      min: 0,
                      max: 10,
                      divisions: 100,
                      activeColor: Colors.red,
                      label: _units.toStringAsPrecision(3),
                      onChanged: (double value) {
                        setState(() {
                          _units = value;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: errorVis
                    ? _patientName.text.length > 0
                        ? Text(
                            'Patient',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )
                        : Text(
                            '*Patent',
                            style: TextStyle(fontSize: 13, color: Colors.red),
                          )
                    : Text(
                        'Patient',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
              ),
              Card(
                elevation: 10,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLengthEnforced: false,
                        onChanged: (value) {
                          print(value);
                          setState(() {});
                        },
                        controller: _patientName,
                        style: TextStyle(color: Colors.black),
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                            hintText: 'Patient name',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        print('gender');
                        if (_gender == 'female') {
                          setState(() {
                            _gender = 'male';
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              _gender == 'male' ? Colors.red : Colors.black12,
                          gradient: _gender == 'male'
                              ? LinearGradient(
                                  colors: [
                                    Color.fromRGBO(33, 31, 37, 0.5),
                                    Colors.red
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                )
                              : null,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Male',
                          style: TextStyle(
                              color:
                                  _gender == 'male' ? Colors.white : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('gender');
                        if (_gender == 'male') {
                          setState(() {
                            _gender = 'female';
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              _gender == 'female' ? Colors.red : Colors.black12,
                          gradient: _gender == 'female'
                              ? LinearGradient(
                                  colors: [
                                    Color.fromRGBO(33, 31, 37, 0.5),
                                    Colors.red
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                )
                              : null,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Female',
                          style: TextStyle(
                              color: _gender == 'female'
                                  ? Colors.white
                                  : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                child: Text(
                  'Relation',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              Card(
                color: Colors.black12,
                elevation: 10,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        print('relation');
                        if (_relation != 'friend') {
                          setState(() {
                            _relation = 'friend';
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              _relation == 'friend' ? Colors.red : Colors.white,
                          gradient: _relation == 'friend'
                              ? LinearGradient(
                                  colors: [
                                    Color.fromRGBO(33, 31, 37, 0.5),
                                    Colors.red
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                )
                              : null,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Friend',
                          style: TextStyle(
                              color: _relation == 'friend'
                                  ? Colors.white
                                  : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 0.5,
                    ),
                    InkWell(
                      onTap: () {
                        print('relation');
                        if (_relation != 'family') {
                          setState(() {
                            _relation = 'family';
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              _relation == 'family' ? Colors.red : Colors.white,
                          gradient: _relation == 'family'
                              ? LinearGradient(
                                  colors: [
                                    Color.fromRGBO(33, 31, 37, 0.5),
                                    Colors.red
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                )
                              : null,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Family',
                          style: TextStyle(
                              color: _relation == 'family'
                                  ? Colors.white
                                  : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 0.5,
                    ),
                    InkWell(
                      onTap: () {
                        print('relation');
                        if (_relation != 'other') {
                          setState(() {
                            _relation = 'other';
                          });
                        }
                      },
                      child: Container(
                        color: _relation == 'other' ? Colors.red : Colors.white,
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Other',
                          style: TextStyle(
                              color: _relation == 'other'
                                  ? Colors.white
                                  : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromRGBO(33, 31, 37, 0.5), Colors.red],
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                    ),
                  ),
                  child: FlatButton(
                      //  color: Colors.red,
                      onPressed: () async {
                        print('search  ${location.keys}');
                        if (address != null &&
                            _date != null &&
                            _time != null &&
                            _patientName.text.isNotEmpty) {
                          print('ok');
                          final request = Request(
                              address: location,
                              coordinates: coordinates,
                              relation: _relation,
                              bloodGroup: bloodGroup,
                              requesterId: AuthServices().user.uid,
                              patientName: _patientName.text,
                              units: _units,
                              date: DateTime(_date.year, _date.month, _date.day,
                                  _time.hour, _time.minute),
                              city: location['address']['city'],
                              requesterName: AuthServices().user.displayName);
                          await DatabaseHandler().addRequest(request);
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text:
                                  "Your blood request was submitted successfully.",
                              onConfirmBtnTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                          // Navigator.pushNamed(context, DonorList.id);
                        } else {
                          setState(() {
                            errorVis = true;
                          });
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: "Oops...",
                            text: "Please fill all the fields.",
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Request for Blood',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
