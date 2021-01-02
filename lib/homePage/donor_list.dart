import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_blood/bussiness_logic/database/database_handler.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/bussiness_logic/services/map_services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorList extends StatefulWidget {
  static const String id = 'donor_list';
  final String bloodGroup;
  final Map<String, dynamic> location;
  DonorList({@required this.location, this.bloodGroup});
  @override
  _DonorListState createState() => _DonorListState();
}

class _DonorListState extends State<DonorList> {
  @override
  Widget build(BuildContext context) {
    //   List<User> donors = Provider.of<List<User>>(context);
    List<User> donors = Provider.of<List<User>>(context)
        .where((user) => user.bloodGroup == widget.bloodGroup)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        shadowColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Donor List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Found ${donors.length} donors with A+ blood group in your location',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: donors.isNotEmpty
            ? ListView.builder(
                itemCount: donors.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () =>
                        buildShowModalBottomSheet(context, donors[index]),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black12,
                          radius: 25,
                          backgroundImage: donors[index].imageUrl != null
                              ? NetworkImage(donors[index].imageUrl)
                              : AssetImage('assets/user_avatars/user1.png'),
                        ),
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                donors[index].userName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                                        donors[index].location['address']
                                            ['city'] +
                                        ' , ' +
                                        donors[index].location['address']
                                            ['postcode'] +
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
                              Container(
                                color: Colors.red,
                                child: InkWell(
                                  splashColor: Colors.black12,
                                  onTap: () async {
                                    print('contact donor');
                                    Map user = await DatabaseHandler()
                                        .fetchUser(donors[index].uid);
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
                                          '   Contact Donor',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ]),
                        trailing: Container(
                          margin: EdgeInsets.only(bottom: 25),
                          height: 30,
                          width: 30,
                          color: Colors.black12,
                          child: Center(
                            child: Text(
                              donors[index].bloodGroup,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/no_data.jpg')),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'No donors in your area !',
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

Future buildShowModalBottomSheet(BuildContext context, User user) {
  final ScrollController controller = new ScrollController();
  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            height: 80,
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.7,
          expand: true,
          builder: (context, scrollController) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                padding: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: ListView(
                  shrinkWrap: true,
                  controller: controller,
                  children: [
                    Center(
                      child: Text(
                        user.userName,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Beginner Donor',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.heartbeat),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '3',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Lives saved',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.drop),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                user.bloodGroup,
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Blood Group',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
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
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Send Request',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                      ),
                    ),
                    Container(
                      height: 0.5,
                      color: Colors.grey,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Image(
                        image: AssetImage('assets/map_mock.jpg'),
                        height: 120,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.location['address']['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  user.location['address']['state'] +
                                      user.location['address']
                                          ['neighbourhood'] +
                                      ',' +
                                      user.location['address']['country'] +
                                      ',' +
                                      user.location['address']['postcode'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                )
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.directions,
                                    color: Colors.red,
                                  ),
                                  onTap: () {
                                    print('get directions');
                                    openMap(user.coordinates.latitude,
                                        user.coordinates.longitude);
                                  },
                                ),
                                Text(
                                  'Get Directions',
                                  style: TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.7 - 40,
          left: MediaQuery.of(context).size.width / 2 - 40,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: user.imageUrl != null
                ? NetworkImage(user.imageUrl)
                : AssetImage('assets/user_avatars/user1.png'),
          ),
        )
      ],
    ),
  );
}
