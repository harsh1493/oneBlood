import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/helperUI/EditInfo.dart';
import 'package:one_blood/utility/utility.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ManageAccount extends StatefulWidget {
  static const String id = 'manage_account';
  final User user;
  ManageAccount({@required this.user});
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //var userDetail = Provider.of<User>(context);
    User userDetail = widget.user;
    print(userDetail.userName + '33333333333333333');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        shadowColor: Colors.transparent,
      ),
      body: Container(
        // padding: EdgeInsets.all(20),
        width: double.infinity,
        color: Colors.white,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5,
              ),
              Material(
                borderRadius: BorderRadius.circular(50),
                elevation: 20,
                child: Stack(children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: StreamBuilder(
                        stream: DatabaseHandler().currentUser,
                        builder: (BuildContext context, user) {
                          User userData = user.data;
                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black12,
                            backgroundImage:
                                NetworkImage(userData.imageUrl ?? altDp),
                          );
                        }),
                  ),
                  Positioned(
                    top: 80,
                    right: 2,
                    child: InkWell(
                      onTap: () {
                        print('edit');
                        edit(context, EditDpWidget());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 15,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 1))),
                child: Row(
                  children: [
                    StreamBuilder(
                      stream: DatabaseHandler().currentUser,
                      builder: (BuildContext context, user) {
                        User userData = user.data;
                        return InfoTile(
                            icon: Icons.account_circle,
                            data: userData.userName,
                            heading: 'User Name');
                      },
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        onPressed: () => edit(context, EditNameWidget()))
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 1))),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InfoTile(
                      icon: FontAwesomeIcons.mars,
                      heading: 'Gender',
                      data: userDetail.gender == 'Gender.male'
                          ? 'male'
                          : 'female',
                    ),
                    Container(
                      width: 1,
                      height: 75,
                      color: Colors.black12,
                    ),
                    InfoTile(
                      icon: CupertinoIcons.drop,
                      heading: 'Blood Group',
                      data: userDetail.bloodGroup,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 1))),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InfoTile(
                      icon: FontAwesomeIcons.calendarAlt,
                      heading: 'Date of Birth',
                      data: dateFormatter(userDetail.dob),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 1))),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InfoTile(
                      icon: Icons.mail,
                      heading: 'Email',
                      data: userDetail.email,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 1))),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InfoTile(
                      icon: Icons.phone,
                      heading: 'Mobile Number',
                      data: userDetail.phoneNumber ?? '8962345568',
                    ),
                    InkWell(
                      onTap: () {
                        print('change');
                      },
                      child: Material(
                        elevation: 5,
                        child: Container(
                          color: Colors.black12,
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'CHANGE',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    //  color: Color.fromRGBO(250, 250, 250, 1),
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 1))),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InfoTile(
                      icon: Icons.home,
                      heading: 'Address',
                      //data: userDetail.address.substring(0, 42),
                      data: ' ' +
                          userDetail.location['address']['city'] +
                          ' , ' +
                          userDetail.location['address']['postcode'],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    //  color: Color.fromRGBO(250, 250, 250, 1),
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 1))),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InfoTile(
                      icon: FontAwesomeIcons.weight,
                      heading: ' Weight',
                      data: ' ' + userDetail.weight.toString(),
                      size: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String data;
  final double size;
  InfoTile(
      {@required this.icon,
      @required this.data,
      @required this.heading,
      @required this.size});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: size ?? 30,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                Text(
                  data,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
