import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/appointments.dart';
import 'package:one_blood/bussiness_logic/models/request.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/constants.dart';
import 'package:one_blood/homePage/eligibility_ui.dart';
import 'package:one_blood/utility/utility.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWelcome extends StatefulWidget {
  static const String id = 'home_welcome';
  @override
  _HomeWelcomeState createState() => _HomeWelcomeState();
}

class _HomeWelcomeState extends State<HomeWelcome> {
  @override
  Widget build(BuildContext context) {
    // Stream<List<Appointment>> appointments =
    //     DatabaseHandler().allAppointments(AuthServices().user.uid);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome \n${AuthServices().user.displayName}',
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () => null,
                              icon: Icon(
                                FontAwesomeIcons.search,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rank',
                                        style: TextStyle(color: Colors.pink),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        width: 50,
                                        height: 0.5,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        '1256',
                                        style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Points'),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        width: 50,
                                        height: 0.5,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        '12.56',
                                        style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            height: 70,
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Cool down',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(7, 46, 92, 1),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900)),
                                      Text('Days till you can donate again',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900)),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.pink,
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '54',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        StreamBuilder(
                            stream: DatabaseHandler()
                                .allAppointments(AuthServices().user.uid),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Appointment>> appointments) {
                              Appointment nextAppointment =
                                  appointments.data == null
                                      ? null
                                      : appointments.data[0];
                              return nextAppointment != null
                                  ? Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        //height: 70,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('YOUR UPCOMING APPOINTMENT',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        7, 46, 92, 1),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                                '${month.values.toList()[nextAppointment.donationDate.month - 1]} ${nextAppointment.donationDate.day}, ${nextAppointment.donationDate.year} at ${timeFormatter(nextAppointment.donationDate)}',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        7, 46, 92, 1),
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                '${nextAppointment.location['display_name']}',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        7, 46, 92, 1),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(
                                                          33, 31, 37, 0.5),
                                                      Colors.red
                                                    ],
                                                    begin: FractionalOffset
                                                        .topLeft,
                                                    end: FractionalOffset
                                                        .bottomRight,
                                                  )),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print('search');
                                                    buildShowModalBottomSheet(
                                                        context);
                                                  },
                                                  child: Container(
                                                    height: 20,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          ' View all appointments',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Icon(
                                                          Icons.navigate_next,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container();
                            }),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Active campaigns',
                                style: TextStyle(
                                    color: Color.fromRGBO(7, 46, 92, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'view all',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image(
                                        image: AssetImage(
                                          'assets/background.jpg',
                                        ),
                                        //color: Colors.white10,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Text(
                                      'One Blood camp',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    bottom: 20,
                                    left: 20,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Who can donate blood?',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'This list of requirements from \nWorld Health Organization(WHO) \ncan help you learn if you can \ndonate blood.',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Image(
                                      image: AssetImage('assets/confuse.png'),
                                      height: 100,
                                      width: 100,
                                    )
                                  ],
                                ),
                                FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)),
                                    onPressed: () async {
                                      const url =
                                          'https://gentle-reaches-98479.herokuapp.com/bloodtips';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Text('See More'))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check if you can give blood?',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\n\n✓ These questions will help you find out \n     if you can give blood.\n',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          '✓ This could save you time \n     or even a wasted journey.\n',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          '✓ Go through them before you go \n     along to your donation.\n',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Image(
                                      image: AssetImage('assets/doc.png'),
                                      height: 140,
                                      width: 100,
                                    )
                                  ],
                                ),
                                FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, EligibilityUi.id);
                                    },
                                    child: Text('Get Started'))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future buildShowModalBottomSheet(BuildContext context) {
  final ScrollController controller = new ScrollController();
  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    // backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      expand: true,
      builder: (context, scrollController) {
        return StreamBuilder(
            stream: DatabaseHandler().allAppointments(AuthServices().user.uid),
            builder: (BuildContext context,
                AsyncSnapshot<List<Appointment>> appointments) {
              return Container(
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(300, 1000),
                        painter: MyPainter(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 20),
                        child: ListView.builder(
                          itemCount: appointments.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AppointmentCard(
                              appointment: appointments.data[index],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      },
    ),
  );
}

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;
  AppointmentCard({this.appointment});

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  Map<String, dynamic> request;
  void getRequest() {
    setState(() async {
      request =
          await DatabaseHandler().fetchRequest(widget.appointment.requestId);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //getRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Text(
            '${weekDay[widget.appointment.donationDate.weekday]},\n${widget.appointment.donationDate.day} ${month.values.toList()[widget.appointment.donationDate.month - 1]} ${widget.appointment.donationDate.year}',
            style: TextStyle(color: Colors.black45),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            widget.appointment.status == 'accepted'
                ? Icons.circle_notifications
                : Icons.check_circle,
            color: widget.appointment.status == 'accepted'
                ? Colors.grey
                : Colors.green,
          ),
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: widget.appointment.status == 'accepted'
                                ? Colors.grey
                                : Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          widget.appointment.status == 'accepted'
                              ? 'Pending'
                              : 'Donated',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color:
                                widget.appointment.appointmentType == 'request '
                                    ? Colors.grey
                                    : Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          widget.appointment.appointmentType == 'request'
                              ? 'To Donate'
                              : 'To Receive',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/user_avatars/user1.png'),
                        radius: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.user,
                                  size: 15,
                                  color: Colors.black54,
                                ),
                                Text(
                                  ' Ae Raju',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 15,
                                  color: Colors.black54,
                                ),
                                Text(
                                  '  ' +
                                      timeFormatter(
                                          widget.appointment.donationDate),
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 15,
                                  color: Colors.black54,
                                ),
                                Text(
                                  widget.appointment.location['display_name']
                                          .toString()
                                          .substring(0, 20) +
                                      '\n' +
                                      widget
                                          .appointment.location['display_name']
                                          .toString()
                                          .substring(20, 40),
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(125, 50);
    final p2 = Offset(125, 1000);
    final paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 2;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
