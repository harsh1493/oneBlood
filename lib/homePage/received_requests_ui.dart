import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/appointments.dart';
import 'package:one_blood/bussiness_logic/models/request.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/bussiness_logic/services/map_services.dart';
import 'package:one_blood/helperUI/ui_components.dart';
import 'package:one_blood/homePage/MapViewSingle.dart';
import 'package:one_blood/homePage/map_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/utility/utility.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ReceivedRequests extends StatefulWidget {
  static const String id = 'received_requests';
  @override
  _ReceivedRequestsState createState() => _ReceivedRequestsState();
}

class _ReceivedRequestsState extends State<ReceivedRequests>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    List<Request> requestList = Provider.of<List<Request>>(context)
        .where((request) =>
            request.requesterId != AuthServices().user.uid &&
            !request.rejecters.contains(AuthServices().user.uid))
        .toList();

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(254, 254, 254, 1),
        padding: EdgeInsets.all(20),
        child: requestList.isNotEmpty
            ? ListView.builder(
                cacheExtent: double.infinity,
                addAutomaticKeepAlives: false,
                itemCount: requestList.length,
                itemBuilder: (BuildContext context, int index) {
                  return RequestCard(
                    request: requestList[index],
                  );
                })
            : Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/no_data.jpg')),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'No new requests !',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pattaya'),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class RequestCard extends StatefulWidget {
  final Request request;
  RequestCard({@required this.request});
  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool accepted = false;

  void accept() {
    setState(() {
      accepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    print(accepted);
    return InkWell(
      onTap: () => buildShowModalBottomSheet(context, widget.request),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black12,
            radius: 25,
            backgroundImage: AssetImage('assets/user_avatars/user1.png'),
          ),
          title: !accepted
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    widget.request.requesterName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        "  ${widget.request.date.day.toString()},${month[widget.request.date.month.toString()]} ",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        CupertinoIcons.time,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        '   ${timeFormatter(widget.request.date)}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        ' ' +
                            widget.request.address['address']['city'] +
                            ' , ' +
                            widget.request.address['address']['postcode'] +
                            // user.city +
                            //  ' (4 kms away)' +
                            ' (' +
                            (Geolocator.distanceBetween(
                                        widget.request.coordinates.latitude,
                                        widget.request.coordinates.longitude,
                                        user.coordinates.latitude,
                                        user.coordinates.longitude) /
                                    1000)
                                .round()
                                .toString() +
                            ' kms away)',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.black12,
                          onTap: () async {
                            await buildShowModalBottomSheet2(
                                context, widget.request, accept);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  '  Accept Request ',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: Colors.black12,
                        child: InkWell(
                          splashColor: Colors.black,
                          onTap: () async {
                            print('reject request');
                            // print(widget.request.rejecters.length);
                            await DatabaseHandler().modifyRequest(
                                {'rejecters': AuthServices().user.uid},
                                widget.request.requestId);
                            print('rejected');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cancel,
                                  size: 15,
                                  color: Colors.black,
                                ),
                                Text(
                                  '  Reject Request ',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ])
              : Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Requested By',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                            Text(widget.request.requesterName,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black))
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Requested For',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                            Text(widget.request.patientName,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black)),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Relation',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                            Text(widget.request.relation,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black))
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          "  ${widget.request.date.day.toString()},${month[widget.request.date.month.toString()]} ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          CupertinoIcons.time,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          '   ${timeFormatter(widget.request.date)}',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          CupertinoIcons.drop_fill,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          ' ${widget.request.units} pints (${widget.request.bloodGroup})',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          ' ' +
                              widget.request.address['address']['city'] +
                              ' , ' +
                              widget.request.address['address']['postcode'] +
                              ' (4 kms away)',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          color: Colors.greenAccent,
                          child: InkWell(
                            splashColor: Colors.white,
                            onTap: () async {
                              print('Request Accepted');
                              await DatabaseHandler().modifyRequest({
                                'status': 'pending',
                                'acceptedBy': null,
                                'accepterId': null
                              }, widget.request.requestId);
                              setState(() {
                                accepted = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    '  Request Accepted ',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          color: Colors.red,
                          child: InkWell(
                            splashColor: Colors.black,
                            onTap: () async {
                              print('contact donor');

                              Map user = await DatabaseHandler()
                                  .fetchUser(widget.request.requesterId);
                              print(user['phoneNumber']);
                              launch("tel://" + user['phoneNumber']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '  Contact ',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          trailing: !accepted
              ? Container(
                  margin: EdgeInsets.only(bottom: 25),
                  width: 30,
                  height: 20,
                  color: Colors.black12,
                  child: Center(
                    child: Text(
                      widget.request.bloodGroup,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

Future buildShowModalBottomSheet(BuildContext context, Request request) {
  final ScrollController controller = new ScrollController();
  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.8,
      expand: true,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            color: Colors.white,
          ),
          child: ListView(
            shrinkWrap: true,
            controller: controller,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(60),
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(33, 31, 37, 0.5),
                                Colors.red
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                            )),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          request.bloodGroup,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${request.bloodGroup} Blood Donor Needed',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Requested by ${request.requesterName}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.drop_fill,
                              size: 15,
                              color: Colors.red,
                            ),
                            Text(
                              ' ${request.units} units',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              CupertinoIcons.location_solid,
                              size: 15,
                              color: Colors.red,
                            ),
                            Text(
                              ' 4 kms ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${request.datePosted.difference(DateTime.now()).inDays.abs() ?? request.datePosted.difference(DateTime.now()).inMinutes}  days ago       ',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(33, 31, 37, 0.5),
                                Colors.red
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                            )),
                        child: FlatButton(
                            onPressed: () {
                              print('search');
                            },
                            child: Container(
                              height: 40,
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '   Offer Help ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.red)),
                          onPressed: () => null,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share,
                                  color: Colors.red,
                                ),
                                Text(
                                  '     Share',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey,
                width: double.infinity,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note by ${request.relation.toUpperCase()} :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${request.patientName} is a major Thalessemia patient,she requires blood transfusion on regular basis.She loves reading book and saturday nights. Your blood donation will help her do things he/she loves',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
              ),
              Container(
                height: 140,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: IgnorePointer(
                  child: MapViewSingle(
                    coordinates: request.coordinates,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: GestureDetector(
                  onTap: () => openMap(request.coordinates.latitude,
                      request.coordinates.longitude),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.address['address']['name'] ??
                                  request.address['address']['city'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              request.address['address']['postcode'] +
                                  ', ' +
                                  request.address['address']['state'] +
                                  ', ' +
                                  request.address['address']['country'],
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.directions,
                              color: Colors.red,
                            ),
                            Text(
                              'Get Directions',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ]),
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}

Future buildShowModalBottomSheet2(
    BuildContext context, Request request, Function accept) {
  final ScrollController controller = new ScrollController();
  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.5,
      expand: true,
      builder: (context, scrollController) {
        return Container(
          height: 200,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Confirm Appointment',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    line(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'with',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            request.requesterName,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    line(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppointmentDetails(
                          iconData: Icons.calendar_today_outlined,
                          text: request.date.day.toString() +
                              ',' +
                              month.values.toList()[request.date.month - 1],
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        AppointmentDetails(
                          iconData: FontAwesomeIcons.clock,
                          text: timeFormatter(request.date),
                        )
                      ],
                    ),
                    line(),
                    SizedBox(
                      height: 10,
                    ),
                    AppointmentDetails(
                      iconData: Icons.location_on,
                      text: request.city,
                    ),
                    line(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              print('Accept request');
                              await DatabaseHandler().modifyRequest({
                                'status': 'accepted',
                                'acceptedBy': AuthServices().user.displayName,
                                'accepterId': AuthServices().user.uid
                              }, request.requestId);
                              accept();
                              Appointment appointment = new Appointment(
                                bloodGroup: request.bloodGroup,
                                requesterId: request.requesterId,
                                requestId: request.requestId,
                                donorId: AuthServices().user.uid,
                                status: 'accepted',
                                location: request.address,
                                appointmentType: 'donation',
                                dateAccepted: DateTime.now(),
                                donationDate: request.date,
                              );
                              DatabaseHandler().addApointment(appointment);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(234, 247, 244, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(234, 247, 244, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class AppointmentDetails extends StatelessWidget {
  @override
  final IconData iconData;
  final String text;
  AppointmentDetails({@required this.iconData, @required this.text});

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: Colors.grey,
            size: 20,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }
}
