import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/request.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/utility/utility.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

int getStatus() {
  Random rnd = new Random();
  int s = 1 + rnd.nextInt(4);
  print(s);
  return s;
}

class MyRequests extends StatefulWidget {
  static const String id = 'my_requests';
  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    List<Request> requestList = Provider.of<List<Request>>(context)
        .where((user) => user.requesterId == AuthServices().user.uid)
        .toList();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Expanded(
          child: ListView.builder(
              cacheExtent: double.infinity,
              addAutomaticKeepAlives: false,
              itemCount: requestList.length,
              itemBuilder: (BuildContext context, int index) {
                return RequestCard(
                  request: requestList[index],
                );
              }),
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
  int status = 1;
  String _status;

  int getStatus() {
    Random rnd = new Random();
    int s = 1 + rnd.nextInt(3);
    print(s);
    setState(() {
      status = s;
    });
    return s;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(month['5']);

    return Card(
      child: ListTile(
        leading: Container(
          margin: EdgeInsets.only(bottom: 25),
          width: 40,
          color: Colors.black12,
          child: Center(
            child: Text(
              widget.request.bloodGroup,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.only(left: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.request.requesterName ?? 'null',
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
            widget.request.status == 'pending'
                ? Row(
                    children: [
                      Container(
                        color: Colors.black12,
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
                                '  Request Pending ',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: InkWell(
                          splashColor: Colors.black,
                          onTap: () async {
                            print('cancel request');
                            await DatabaseHandler()
                                .deleteRequest(widget.request.requestId);
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
                                  '  Cancel Request ',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : widget.request.status == 'accepted'
                    ? Row(
                        children: [
                          Container(
                            color: Colors.greenAccent,
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
                                    '    Request Accepted By \n    ${widget.request.acceptedBy}',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                ],
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
                                    .fetchUser(widget.request.accepterId);
                                print(user['phoneNumber']);
                                //launch("tel://" + user['phoneNumber']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
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
                      )
                    : Row(
                        children: [
                          Container(
                            color: Colors.greenAccent,
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
                                    '    Donation Successful',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
            SizedBox(
              height: 5,
            ),
          ]),
        ),
      ),
    );
  }
}
