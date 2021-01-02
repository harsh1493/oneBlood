import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/posts.dart';
import 'package:one_blood/bussiness_logic/models/request.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/bussiness_logic/services/location.dart';
import 'package:one_blood/constants.dart';
import 'package:one_blood/homePage/add_request_ui.dart';
import 'package:one_blood/homePage/find_donors_ui.dart';
import 'package:one_blood/homePage/home_welcome.dart';
import 'package:one_blood/homePage/map_view.dart';
import 'package:one_blood/homePage/notifications_ui.dart';
import 'package:one_blood/homePage/profile_ui.dart';
import 'package:one_blood/homePage/requests_ui.dart';
import 'package:one_blood/ui/pre_signin_ui/welcome_ui.dart';
import 'package:provider/provider.dart';
import 'custom_icons.dart' as CustomIcons;

class HomePageUi extends StatefulWidget {
  static const String id = 'home_page';
  @override
  _HomePageUiState createState() => _HomePageUiState();
}

class _HomePageUiState extends State<HomePageUi>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  String address;
  AnimationController _animationController;
  Animation _animation;
  Animation _animation2;
  AnimationController _animationController2;
  bool b = false;
  int index = 2;
  final _pageViewController = PageController(
    initialPage: 2,
  );

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to logout '),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  // Navigator.pushNamed(context, WelcomeUi.id);
                  Navigator.pushNamedAndRemoveUntil(
                      context, WelcomeUi.id, (r) => false);
                  AuthServices().signOut();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    // _animationController2 = AnimationController(
    //   vsync: this,
    //   duration: Duration(
    //     milliseconds: 500,
    //   ),
    //   lowerBound: 0.8,
    //   upperBound: 1.0,
    // )..addListener(() {
    //     setState(() {});
    //   });

    // _animationController2.repeat(reverse: true);
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceIn,
    );
    // TODO: implement initState
    _animationController.addListener(() {
      setState(() {});
      //print(controller.value);
      //  print(_animation.value);
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MultiProvider(
        providers: [
          StreamProvider<User>.value(value: DatabaseHandler().currentUser),
          StreamProvider<List<Post>>.value(
            value: DatabaseHandler().allPost,
          ),
        ],
        child: Scaffold(
          body: Stack(children: [
            Center(
                child: PageView(
              controller: _pageViewController,
              onPageChanged: (i) {
                index = i;
                print(i);
                _animationController.forward(from: 0.6);
              },
              children: [
                FindDonorsUi(),
                RequestsUi(),
                HomeWelcome(),
                Notifications(),
                ProfileUi(),
              ],
            )),
            Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: shadowList, color: Colors.transparent),
                  width: size.width,
                  height: 80,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(size.width, 80),
                        painter: BNBCustomPainter(),
                      ),
                      Center(
                        heightFactor: 0.6,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AddRequest.id);
                          },
                          backgroundColor: Colors.red,
                          child: Container(
                            height: 55,
                            width: 60,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(100, 31, 37, 0.8),
                                    Colors.red
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                ),
                                shape: BoxShape.circle),
                            child: Icon(
                              //Icons.add,
                              CustomIcons.MyFlutterApp.blood_drop,
                              color: Colors.white,
                            ),
                          ),
                          elevation: 10,
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.searchPlus,
                                        size: index == 0
                                            ? b
                                                ? 30 * _animation.value
                                                : 30
                                            : 25,
                                        color: index == 0
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          b = true;
                                          index = 0;
                                          _pageViewController.jumpToPage(0);
                                        });
                                      }),
                                  Text(
                                    'Find Donors',
                                    style: TextStyle(
                                        color: index == 0
                                            ? Colors.redAccent
                                            : Colors.grey,
                                        fontSize: index == 0
                                            ? b
                                                ? 12 * _animation.value
                                                : 12
                                            : 10),
                                  )
                                ],
                              ),
                              margin: EdgeInsets.only(top: 10),
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.clipboardList,
                                      size: index == 1
                                          ? 30 * _animation.value
                                          : 25,
                                      color: index == 1
                                          ? Colors.redAccent
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        index = 1;
                                        _pageViewController.jumpToPage(index);
                                      });
                                    }),
                                Text(
                                  'Requests',
                                  style: TextStyle(
                                      color:
                                          index == 1 ? Colors.red : Colors.grey,
                                      fontSize: index == 1
                                          ? 12 * _animation.value
                                          : 10),
                                )
                              ],
                            ),
                            SizedBox(
                              width: size.width * 0.20,
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.notifications,
                                      size: index == 3
                                          ? 30 * _animation.value
                                          : 25,
                                      color: index == 3
                                          ? Colors.redAccent
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        index = 3;
                                        _pageViewController.jumpToPage(index);
                                      });
                                    }),
                                Text(
                                  'Notification',
                                  style: TextStyle(
                                      color:
                                          index == 3 ? Colors.red : Colors.grey,
                                      fontSize: index == 3
                                          ? 12 * _animation.value
                                          : 10),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(children: [
                                IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.user,
                                      size: index == 4
                                          ? 30 * _animation.value
                                          : 25,
                                      color: index == 4
                                          ? Colors.redAccent
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        index = 4;
                                        _pageViewController.jumpToPage(index);
                                      });
                                    }),
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                      color:
                                          index == 4 ? Colors.red : Colors.grey,
                                      fontSize: index == 4
                                          ? 12 * _animation.value
                                          : 10),
                                )
                              ]),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
