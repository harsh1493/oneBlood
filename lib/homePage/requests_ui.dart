import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_blood/bussiness_logic/models/request.dart';
import 'package:one_blood/bussiness_logic/models/user.dart';
import 'package:one_blood/bussiness_logic/services/auth_services.dart';
import 'package:one_blood/homePage/my_requests.dart';
import 'package:one_blood/homePage/received_requests_ui.dart';
import 'package:provider/provider.dart';

class RequestsUi extends StatefulWidget {
  static const String id = 'requests_ui';
  @override
  _RequestsUiState createState() => _RequestsUiState();
}

class _RequestsUiState extends State<RequestsUi>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<User> topDonors = Provider.of<List<User>>(context)
        .where((user) => user.wannaDonate)
        .toList();
    print(topDonors.first.wannaDonate);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 240.0,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Requests for Blood',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.pink),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'See received blood requests and also check your request status',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Top Donors',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topDonors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black12,
                              radius: 25,
                              backgroundImage: AssetImage(
                                  'assets/user_avatars/user' +
                                      getStatus().toString() +
                                      '.png'),
                            ),
                            Text(
                              topDonors[index].userName,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          tabs: [
            Tab(
              child: Text(
                'Received Requests',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Tab(
                child: Text(
              'My Requests',
              style: TextStyle(color: Colors.black, fontSize: 16),
            )),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [ReceivedRequests(), MyRequests()],
      ),
    );
  }
}
