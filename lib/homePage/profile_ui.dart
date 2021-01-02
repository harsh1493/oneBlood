import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/homePage/manage_account.dart';
import 'package:one_blood/ui/pre_signin_ui/welcome_ui.dart';
import 'package:provider/provider.dart';

class ProfileUi extends StatefulWidget {
  static const String id = 'profile_ui';
  @override
  _ProfileUiState createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi>
    with SingleTickerProviderStateMixin {
  bool animate = false;
  bool _notification = false;

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
    // TODO: implement initState
    setState(() {
      animate = false;
    });
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        animate = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    // setState(() {});
    //print(user.userName);

    return Scaffold(
        //extendBody: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80.0,
          elevation: 0,
          title: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.pink),
                  ),
                  Text(
                    'Manage your profile here',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              )),
          actions: [IconButton(icon: Icon(Icons.settings), onPressed: null)],
        ),
        body: Container(
          // padding: EdgeInsets.all(10),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 80.0),
          width: double.infinity,
          child: Expanded(
            child: ListView(
              children: [
                Card(
                  color: Colors.transparent,
                  elevation: 20,
                  shadowColor: Colors.red,
                  child: Container(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image(
                            image: user.imageUrl == null
                                ? AssetImage('assets/user_avatars/dp.jpg')
                                : NetworkImage(user.imageUrl),
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          ),
                          Container(
                            color: Colors.white12,
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  user.userName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Beginner Donor',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      animate = !animate;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white30,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                )
                              ],
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 400),
                            top: 40,
                            right: animate ? 35 : -100,
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.heartbeat,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  '  4 lives saved',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            top: 90,
                            right: animate ? 60 : -100,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  '  40 likes',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 200),
                            top: 140,
                            right: animate ? 15 : -200,
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.drop_fill,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  ' ${user.bloodGroup} blood group',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: AnimatedSize(
                    vsync: this,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      width: animate ? 400 : 0,
                      height: animate ? 120 : 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today_outlined),
                                    Text(
                                      ' 14th  Nov',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ' Last Donation',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'few days ago',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              elevation: 10,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today_outlined),
                                    Text(
                                      ' 3rd  Dec',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ' Next Donation',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '2 days left',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today_sharp),
                                    Text(
                                      ' 1 Donation',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ' This Month',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        !user.wannaDonate
                            ? CupertinoIcons.heart
                            : CupertinoIcons.heart_fill,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'I want to donate',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Switch(
                          activeColor: Colors.white,
                          activeTrackColor: Colors.red,
                          value: user.wannaDonate,
                          onChanged: (bool value) {
                            setState(() {
                              // database.user.wannaDonate = value;
                              DatabaseHandler()
                                  .modifyUser({'wannaDonate': value});
                            });
                          }),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    print('');

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ManageAccount(user: user);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Manage Account',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Credits & Redeem',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        !_notification
                            ? CupertinoIcons.bell
                            : CupertinoIcons.bell_fill,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Notification',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Switch(
                          activeColor: Colors.white,
                          activeTrackColor: Colors.red,
                          value: _notification,
                          onChanged: (bool value) {
                            setState(() {
                              _notification = value;
                            });
                          }),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    print('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'About',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _onWillPop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
