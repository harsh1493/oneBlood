import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:one_blood/bussiness_logic/services/location.dart';
import 'package:one_blood/constants.dart';
import 'package:one_blood/homePage/donor_list.dart';
import 'package:shimmer/shimmer.dart';

class FindDonorsUi extends StatefulWidget {
  static const String id = 'find_donors';
  @override
  _FindDonorsUiState createState() => _FindDonorsUiState();
}

class _FindDonorsUiState extends State<FindDonorsUi> {
  bool animate = false;
  String bloodGroup = '';
  int selected = 0;
  TextEditingController _postalAddress;
  bool isFetchingLocation = false;
  GeoPoint coordinates;
  String address;
  Map<String, dynamic> location;

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
    bool errorVis = true;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 80),
      color: Colors.white,
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Find Donor',
                style: TextStyle(
                    color: Colors.pink,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Search for blood donors around you',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 25,
            ),
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
              padding: const EdgeInsets.all(8.0),
              child: Text(
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

                location = await Location.reverseGeocodedLocation();

                setState(() {
                  isFetchingLocation = false;
                  address = location["address"]["city"] +
                      ' ,' +
                      location['address']['postcode'] +
                      ' , ' +
                      location['address']['country'];
                });
                coordinates = await Location.getLocation();
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
                                : Colors.black,
                            highlightColor: isFetchingLocation
                                ? Colors.yellow
                                : Colors.black,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ))
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Color.fromRGBO(33, 31, 37, 0.5), Colors.red],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                )),
                child: FlatButton(
                    onPressed: () {
                      print('search');
                      //Navigator.pushNamed(context, DonorList.id);
                      location == null
                          ? Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Please add your location')))
                          : Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return DonorList(
                                bloodGroup: b.values.toList()[selected],
                                location: location,
                              );
                            }));
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Search Donors',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: FlatButton(
                  color: Colors.black12,
                  splashColor: Colors.black,
                  onPressed: () {
                    print('search');
                    location == null
                        ? Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Please add your location')))
                        : Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                            return DonorList(
                              bloodGroup: b.values.toList()[selected],
                              location: location,
                            );
                          }));
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Emergency Search',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
